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

---

### 2. Architecture Overview

We’ll implement a **minimal Korz kernel** in Pharo, organised roughly as:

* **Core model**

  * `KzSlotSpace`
  * `KzCoordinate`
  * `KzDimension`
  * `KzSlotGuard`
  * `KzSlot`
* **Dispatch / context**

  * `KzContext` (dimension bindings)
  * `KzDispatcher`
* **Projection layer**

  * `KzProjection` (defines a perspective)
  * `KzProjectionObject` (proxy / façade for that projection)
* **GT integration**

  * `KzSlotSpace >> gtInspectorOn:`
  * `KzProjectionObject >> gtInspectorOn:`
* **Examples & tests**

  * `KzProjectionExamples`
  * `KzProjectionTests`

Package suggestion: `Korz-Projection-Model`, `Korz-Projection-GToolkit`, `Korz-Projection-Tests`.

---

### 3. Phase 1 – Core Slot Model

#### 3.1 KzCoordinate

* **Responsibility:** Identity atom; no slots inside.
* **State:**

  * `id` (UUID or incrementing integer).
  * Optional `name` for debugging (e.g. #screenParent).
  * Optional `parent` (`KzCoordinate` or nil).
* **Behaviour:**

  * `<=` / `isAtMostAsGeneralAs:` implementing the `≼` relation.
  * `ancestors` including `self`.
  * `printOn:` for readable GT views.

#### 3.2 KzDimension

* **Responsibility:** Named dimension.
* **State:** `name` (Symbol).
* **And maybe:** `description` for GT views.

#### 3.3 KzSlotGuard

* **Responsibility:** Korz guard triple (dimension constraints, selector, parameter constraints).
* **State:**

  * `dimensionConstraints` – Dictionary<KzDimension -> KzCoordinate>.
  * `selector` – Symbol.
  * `parameterConstraints` – Array<KzCoordinate> or `nil` for unconstrained.
* **Behaviour:**

  * `matchesContext:arguments:` – implements `dbs ⊑ dcs` and `args ⊑ pct`.
  * `isMoreSpecificThan:` – implements the `≼` rule for slot guards.
  * Helpers:

    * `hasDimension:`
    * `coordinateForDimension:`

#### 3.4 KzSlot

* **Responsibility:** The fundamental “particle”: guard + contents.
* **State:**

  * `guard : KzSlotGuard`
  * `contents` – one of:

    * A **coordinate** (data slot).
    * An **assignment primitive** (we can model as a special symbol / block).
    * A **method body** (Pharo block closure) with agreed calling convention.
* **Behaviour:**

  * `evaluateInContext:withArguments:` → `KzCoordinate` (or Pharo value that we wrap).

*(For v1 we can treat “values” as either `KzCoordinate` or raw Smalltalk values, but keep the API clean so we can wrap later.)*

#### 3.5 KzSlotSpace

* **Responsibility:** Registry of dimensions, coordinates, slots.
* **State:**

  * `dimensions` (Set<KzDimension>)
  * `coordinates` (Set<KzCoordinate>)
  * `slots` (Set<KzSlot>)
* **Behaviour:**

  * Creation helpers:

    * `newCoordinateNamed:parent:`
    * `dimensionNamed:` (creates or returns existing).
    * `addSlot:` / `removeSlot:`.
  * Lookup:

    * `lookupSlotForContext:selector:arguments:` → `KzSlot | KzAmbiguous | KzNotFound`

      * Uses `KzDispatcher` (see below).

---

### 4. Phase 2 – Context & Dispatch

#### 4.1 KzContext

* **Responsibility:** Dimension binding set (the Korz “context”).
* **State:** `bindings` – Dictionary<KzDimension -> KzCoordinate>.
* **Behaviour:**

  * `atDimension:` / `atDimension:put:`.
  * `satisfiesDimensionConstraints:` – check `dbs ⊑ dcs`.
  * `modifiedBy:` – apply “dimension modifiers” (e.g. add/remove bindings).

*(We don’t need full syntax sugar; just keep API close enough to the paper to be recognisable.)*

#### 4.2 KzDispatcher

* **Responsibility:** Slot lookup + ambiguity handling.
* **Behaviour:**

  * `dispatchIn:slotSpace selector: selector arguments: args context: ctx`

    * Step 1: Filter slots with matching selector.
    * Step 2: Filter by guard `matchesContext:arguments:`.
    * Step 3: Remove less specific guards (per paper’s `removeLessSpecific`).
    * Step 4:

      * |0| → raise `KzMessageNotUnderstood`.
      * |1| → evaluate that slot.
      * > 1 → raise `KzAmbiguousDispatch`. *(Future: an interpreter-dimension can override this.)*

---

### 5. Phase 3 – Projection Objects

This is where we get **“objects as locally coherent projections”**.

#### 5.1 KzProjection

* **Responsibility:** Defines how to slice the slot space into projection-objects.
* **Parameters / State:**

  * `slotSpace : KzSlotSpace`
  * `primaryDimension : KzDimension`
    (e.g. `rcvr`, `location`, `isColorblind`… the thing we treat as “receiver identity”.)
  * `fixedContext : KzContext`
    (bindings for *other* dimensions that define this perspective.)
* **Behaviour:**

  * `projectionObjects` → collection of `KzProjectionObject`

    * one per relevant coordinate in `primaryDimension`.
  * `projectCoordinate:` → `KzProjectionObject`.

#### 5.2 KzProjectionObject

* **Responsibility:** A façade for one coordinate under a given projection.
* **State:**

  * `projection : KzProjection`
  * `coordinate : KzCoordinate` (point we’re “looking at”).
* **Behaviour:**

  * `perform: withArguments:`:

    * Build `context = projection.fixedContext + { primaryDimension → coordinate }`.
    * Call `KzDispatcher`.
  * `doesNotUnderstand:` to hook regular message sends:

    * Map `aMessage selector` + `aMessage arguments` to `perform:withArguments:`.
  * Introspection helpers:

    * `availableSelectors` – all selectors with at least one matching slot for this coordinate and context.
    * `slotsForSelector:` – for GT views.

**Effect:**
For a given projection:

* `KzProjection primaryDimension: rcvr fixedContext: { location = australia }`

you can get:

* `screenView := projection projectCoordinate: screenCoord.`
  and now `screenView drawPixelX:Y:color:` does Korz-style guarded dispatch, but *feels* like a normal Pharo object.

Different projections over the same slot space will yield **different object views** (subjective “objects”).

---

### 6. Phase 4 – GT Integration

#### 6.1 Inspectors for KzSlotSpace

* Implement `KzSlotSpace >> gtInspectorOn:`:

  * Show:

    * List of dimensions.
    * List of coordinates grouped by dimension (or with parent info).
    * Slots grouped by selector or by primary dimension.
  * Provide actions:

    * “Open projection on dimension…” → creates a `KzProjection` and opens it.

#### 6.2 Inspectors for KzProjectionObject

* Implement `KzProjectionObject >> gtInspectorOn:`:

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

**Example methods (class KzProjectionExamples):**

* `exampleScreenProjectionRcvrDimension`

  * Build slotSpace and projection (`primaryDimension: rcvr; fixedContext: empty`).
  * Show some `KzProjectionObject`s and call methods.
* `exampleLocationProjection`

  * Projection on `location` dimension: primaryDimension = location; fixedContext includes `rcvr = screen`.
  * Demonstrate that “objects” now look like `#australia`, `#antarctica` etc.
* `exampleSubjectivitySameSlotDifferentObjects`

  * Show same physical slot appearing in two different projection-objects (e.g. as method on `screenParent` vs `southernHemi`).

#### 7.2 Tests (KzProjectionTests)

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

   * Add a pluggable “onAmbiguous:” / “onNotUnderstood:” strategy taking `KzContext`.
2. **Ensembles**

   * Optional flag or dimension value that changes `KzDispatcher` policy to “run all matching slots and combine results”.
3. **Pattern-based selectors**

   * A variant of `KzSlotGuard` where selector is a pattern instead of a single symbol.

Document these hooks in the code so pharo-code-emitter can target them later.

---

### 9. Work Breakdown & Ordering

1. **Core model**

   * Implement `KzCoordinate`, `KzDimension`, `KzSlotGuard`, `KzSlot`, `KzSlotSpace`.
2. **Context & dispatch**

   * Implement `KzContext`, `KzDispatcher`.
   * Add unit tests for specificity and ambiguity.
3. **Projection layer**

   * Implement `KzProjection` & `KzProjectionObject` with `doesNotUnderstand:`.
   * Add tests for subjectivity (same slots, different objects).
4. **GT integration**

   * Add inspectors for SlotSpace and ProjectionObject.
5. **Examples + narrative tests**

   * Recreate a minimal form of the Korz “screen/location/isColorblind” story.
6. **Refinement & hooks**

   * Add extension points for interpreter dimensions and ensembles.

---

If you’d like, next step can be: *“pharo-code-emitter: implement Phase 1 classes for package `Korz-Projection-Model`”* and we turn this into concrete Smalltalk `Class { ... }` definitions.
