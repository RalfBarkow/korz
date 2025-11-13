## IMPLEMENTATION_PLAN.md

**Project:** pharo-code-emitter – Korz-style “projection objects”
**Goal:** Implement “objects” that are *locally coherent projections of many interlinked slots* (Korz-style subjective objects) in Pharo/Glamorous Toolkit.

---

### 1. Scope & Outcomes

**We want:**

* A small Pharo library that models:

  * **Slots** with multidimensional guards (dimensions → coordinates, selector, parameters).
  * A **SlotSpace** (the “sea of slots”).
  * **Projections** that present slices of the slot space as conventional “objects”.
* A **ProjectionObject** API so user code can do:

  * `projObject perform: #drawPixel with: {x. y. color}`
    and have that dispatched via Korz-style guard matching.
* Glamorous Toolkit support:

  * GT inspectors/viewers for:

    * SlotSpace (dimensions, coordinates, slots).
    * ProjectionObject “as if” it were a normal object.
* Example + tests that mimic the **screen / location / isColorblind** Korz example, to validate the mental model.

**Out of scope for first iteration:**

* Full general Korz language / syntax.
* Interpreter-modifying dimensions (e.g. failure/ambiguity hooks) beyond a simple error strategy.
* Ensembles (“run all slots”) — just keep a clear seam for them.

### 1.1 Falsifier checkpoints

From the Lepiter “Falsifier’s report”, we extract the following guardrails:

1. **Baseline first:** Ship a faithful Korz kernel (unique most-specific dispatch) before experimenting with combiners/ensembles.
2. **No anti-reflex ban:** Guards may constrain the same dimension they bind; any “boundary cannot see itself” rule must become a separate meta-dimension or static analysis pass.
3. **Concrete data stories:** Concepts like Yoneda profiles, piles/selection strategies, or Croquet/Syndicate epochs stay in RESEARCH until we can encode them explicitly as coordinates + slots.
4. **Combiners as strategies:** Ensemble modes (`meet`, `sum`, `quorum(k)`, etc.) arrive through dispatcher strategy objects, not via naïvely adding a `combiner` coordinate to guards.
5. **Scope honesty:** SPEC/RESEARCH must keep these limitations visible so we do not over-promise “implement tomorrow” abstractions without the runtime support.

---

### 2. Architecture Overview

We’ll implement a **minimal Korz kernel** in Pharo, organised roughly as:

* **Core model**

  * `KoSlotSpace`
  * `KoCoordinate`
  * `KoDimension`
  * `KoSlotGuard`
  * `KoSlot`
* **Dispatch / context**

  * `KoContext` (dimension bindings)
  * `KoDispatcher`
* **Projection layer**

  * `KoProjection` (defines a perspective)
  * `KoProjectionObject` (proxy / façade for that projection)
* **GT integration**

  * `KoSlotSpace >> gtInspectorOn:`
  * `KoProjectionObject >> gtInspectorOn:`
* **Examples & tests**

  * `KoProjectionExamples`
  * `KoProjectionTests`

Package suggestion: `Korz-Projection-Model`, `Korz-Projection-GToolkit`, `Korz-Projection-Tests`.

---

### 3. Phase 1 – Core Slot Model

#### 3.1 KoCoordinate

* **Responsibility:** Identity atom; no slots inside.
* **State:**

  * `id` (UUID or incrementing integer).
  * Optional `name` for debugging (e.g. #screenParent).
  * Optional `parent` (`KoCoordinate` or nil).
* **Behaviour:**

  * `<=` / `isAtMostAsGeneralAs:` implementing the `≼` relation.
  * `ancestors` including `self`.
  * `printOn:` for readable GT views.

#### 3.2 KoDimension

* **Responsibility:** Named dimension.
* **State:** `name` (Symbol).
* **And maybe:** `description` for GT views.

#### 3.3 KoSlotGuard

* **Responsibility:** Korz guard triple (dimension constraints, selector, parameter constraints).
* **State:**

  * `dimensionConstraints` – Dictionary<KoDimension -> KoCoordinate>.
  * `selector` – Symbol.
  * `parameterConstraints` – Array<KoCoordinate> or `nil` for unconstrained.
* **Behaviour:**

  * `matchesContext:arguments:` – implements `dbs ⊑ dcs` and `args ⊑ pct`.
  * `isMoreSpecificThan:` – implements the `≼` rule for slot guards.
  * Helpers:

    * `hasDimension:`
    * `coordinateForDimension:`

#### 3.4 KoSlot

* **Responsibility:** The fundamental “particle”: guard + contents.
* **State:**

  * `guard : KoSlotGuard`
  * `contents` – one of:

    * A **coordinate** (data slot).
    * An **assignment primitive** (we can model as a special symbol / block).
    * A **method body** (Pharo block closure) with agreed calling convention.
* **Behaviour:**

  * `evaluateInContext:withArguments:` → `KoCoordinate` (or Pharo value that we wrap).

*(For v1 we can treat “values” as either `KoCoordinate` or raw Smalltalk values, but keep the API clean so we can wrap later.)*

#### 3.5 KoSlotSpace

* **Responsibility:** Registry of dimensions, coordinates, slots.
* **State:**

  * `dimensions` (Set<KoDimension>)
  * `coordinates` (Set<KoCoordinate>)
  * `slots` (Set<KoSlot>)
* **Behaviour:**

  * Creation helpers:

    * `newCoordinateNamed:parent:`
    * `dimensionNamed:` (creates or returns existing).
    * `addSlot:` / `removeSlot:`.
  * Lookup:

    * `lookupSlotForContext:selector:arguments:` → `KoSlot | KoAmbiguous | KoNotFound`

      * Uses `KoDispatcher` (see below).

---

### 4. Phase 2 – Context & Dispatch

#### 4.1 KoContext

* **Responsibility:** Dimension binding set (the Korz “context”).
* **State:** `bindings` – Dictionary<KoDimension -> KoCoordinate>.
* **Behaviour:**

  * `atDimension:` / `atDimension:put:`.
  * `satisfiesDimensionConstraints:` – check `dbs ⊑ dcs`.
  * `modifiedBy:` – apply “dimension modifiers” (e.g. add/remove bindings).

*(We don’t need full syntax sugar; just keep API close enough to the paper to be recognisable.)*

#### 4.2 KoDispatcher

* **Responsibility:** Slot lookup + ambiguity handling.
* **Behaviour:**

  * `dispatchIn:slotSpace selector: selector arguments: args context: ctx`

    * Step 1: Filter slots with matching selector.
    * Step 2: Filter by guard `matchesContext:arguments:`.
    * Step 3: Remove less specific guards (per paper’s `removeLessSpecific`).
    * Step 4:

      * |0| → raise `KoMessageNotUnderstood`.
      * |1| → evaluate that slot.
      * > 1 → raise `KoAmbiguousDispatch`. *(Future: an interpreter-dimension can override this.)*

---

### 5. Phase 3 – Projection Objects

This is where we get **“objects as locally coherent projections”**.

#### 5.1 KoProjection

* **Responsibility:** Defines how to slice the slot space into projection-objects.
* **Parameters / State:**

  * `slotSpace : KoSlotSpace`
  * `primaryDimension : KoDimension`
    (e.g. `rcvr`, `location`, `isColorblind`… the thing we treat as “receiver identity”.)
  * `fixedContext : KoContext`
    (bindings for *other* dimensions that define this perspective.)
* **Behaviour:**

  * `projectionObjects` → collection of `KoProjectionObject`

    * one per relevant coordinate in `primaryDimension`.
  * `projectCoordinate:` → `KoProjectionObject`.

#### 5.2 KoProjectionObject

* **Responsibility:** A façade for one coordinate under a given projection.
* **State:**

  * `projection : KoProjection`
  * `coordinate : KoCoordinate` (point we’re “looking at”).
* **Behaviour:**

  * `perform: withArguments:`:

    * Build `context = projection.fixedContext + { primaryDimension → coordinate }`.
    * Call `KoDispatcher`.
  * `doesNotUnderstand:` to hook regular message sends:

    * Map `aMessage selector` + `aMessage arguments` to `perform:withArguments:`.
  * Introspection helpers:

    * `availableSelectors` – all selectors with at least one matching slot for this coordinate and context.
    * `slotsForSelector:` – for GT views.

**Effect:**
For a given projection:

* `KoProjection primaryDimension: rcvr fixedContext: { location = australia }`

you can get:

* `screenView := projection projectCoordinate: screenCoord.`
  and now `screenView drawPixelX:Y:color:` does Korz-style guarded dispatch, but *feels* like a normal Pharo object.

Different projections over the same slot space will yield **different object views** (subjective “objects”).

---

### 6. Phase 4 – GT Integration

#### 6.1 Inspectors for KoSlotSpace

* Implement `KoSlotSpace >> gtInspectorOn:`:

  * Show:

    * List of dimensions.
    * List of coordinates grouped by dimension (or with parent info).
    * Slots grouped by selector or by primary dimension.
  * Provide actions:

    * “Open projection on dimension…” → creates a `KoProjection` and opens it.

#### 6.2 Inspectors for KoProjectionObject

* Implement `KoProjectionObject >> gtInspectorOn:`:

  * Header: coordinate name + primary dimension + summary of fixedContext.
  * Tabs:

    * **Selectors** – list `availableSelectors`, selecting one shows slots and guards.
    * **Slots** – raw slot list for this coordinate.
    * **Context** – pretty view of the effective context used for dispatch.

This turns the “sea of slots” into something GT-browsable and moldable.

---

### 7. Phase 5 – Examples & Tests

#### 7.1 Example: Screen / Location / isColorblind

Implement a tiny Korz-style model in tests:

* Coordinates:

  * `screenParent`, `screen`
  * `locationParent`, `location`, `southernHemi`, `australia`, `antarctica`
  * `trueCoord`, `falseCoord` for `isColorblind`.
* Dimensions:

  * `rcvr`, `location`, `isColorblind`.
* Slots:

  * Baseline `drawPixel(x, y, color)` for `rcvr ≤ screenParent`.
  * `drawPixel` override for `location ≤ southernHemi`.
  * `drawPixel` override for `isColorblind ≤ true`.
  * Combined case for `isColorblind ≤ true` and `location ≤ southernHemi` (as in the paper).

**Example methods (class KoProjectionExamples):**

* `exampleScreenProjectionRcvrDimension`

  * Build slotSpace and projection (`primaryDimension: rcvr; fixedContext: empty`).
  * Show some `KoProjectionObject`s and call methods.
* `exampleLocationProjection`

  * Projection on `location` dimension: primaryDimension = location; fixedContext includes `rcvr = screen`.
  * Demonstrate that “objects” now look like `#australia`, `#antarctica` etc.
* `exampleSubjectivitySameSlotDifferentObjects`

  * Show same physical slot appearing in two different projection-objects (e.g. as method on `screenParent` vs `southernHemi`).

#### 7.2 Tests (KoProjectionTests)

* **Dispatch correctness:**

  * When `context = { rcvr: screen, location: australia }` dispatch chooses the southernHemisphere slot.
  * When `context` also includes `isColorblind: true`, ambiguity is resolved by more-specific guard (per model).
* **Projection behaviour:**

  * For a projection on `rcvr`, `projection projectionObjects` contains expected count and coordinates.
  * For a projection on `location`, the same slot appears under multiple projection-objects.
* **GT smoke tests:**

  * Opening inspectors doesn’t crash (no infinite recursion / DNU loops).

---

### 8. Phase 6 – Extension Hooks (for later)

Leave clear seams for future work, but don’t implement yet:

1. **Interpreter-behaviour dimensions**

   * Add a pluggable “onAmbiguous:” / “onNotUnderstood:” strategy taking `KoContext`.
2. **Ensembles / combiners**

   * Provide dispatcher strategy objects that can deliberately “run all matching slots” (meet/sum/quorum/fixpoint) without polluting ordinary guard coordinates.
3. **Pattern-based selectors**

   * A variant of `KoSlotGuard` where selector is a pattern instead of a single symbol.

Document these hooks in the code so pharo-code-emitter can target them later.

---

### 9. Work Breakdown & Ordering

1. **Core model**

   * Implement `KoCoordinate`, `KoDimension`, `KoSlotGuard`, `KoSlot`, `KoSlotSpace`.
2. **Context & dispatch**

   * Implement `KoContext`, `KoDispatcher`.
   * Add unit tests for specificity and ambiguity.
3. **Projection layer**

   * Implement `KoProjection` & `KoProjectionObject` with `doesNotUnderstand:`.
   * Add tests for subjectivity (same slots, different objects).
4. **GT integration**

   * Add inspectors for SlotSpace and ProjectionObject.
5. **Examples + narrative tests**

   * Recreate a minimal form of the Korz “screen/location/isColorblind” story.
   * Only after the kernel is stable, prototype one “pile/selection strategy” scenario with an explicit slot-encoded graph.
6. **Refinement & hooks**

   * Add extension points for interpreter dimensions and ensembles.
   * Design dispatcher strategy objects (ensemble/combiner policies) so “run all slots” lives outside plain guard coordinates.

---

If you’d like, next step can be: *“pharo-code-emitter: implement Phase 1 classes for package `Korz-Projection-Model`”* and we turn this into concrete Smalltalk `Class { ... }` definitions.
