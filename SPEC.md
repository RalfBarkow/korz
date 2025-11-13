# SPEC

## Goal
Deliver a minimal-yet-usable Korz-style projection-object kernel for Pharo/Glamorous Toolkit, enabling “objects as coherent projections of slots” with dispatch over multidimensional guards.

## Scope
- Core model: `KoCoordinate`, `KoDimension`, `KoSlotGuard`, `KoSlot`, `KoSlotSpace`.
- Context & dispatch: `KoContext`, `KoDispatcher`, specificity + ambiguity resolution rules.
- Projection layer: `KoProjection`, `KoProjectionObject` (with `doesNotUnderstand:` forwarding).
- Glamorous Toolkit inspectors for slot spaces and projection objects.
- Example + tests mirroring the Korz screen/location/isColorblind narrative.

## Non-goals (v1)
- Full Korz language or syntax surface.
- Interpreter-modifying dimensions beyond a pluggable ambiguity strategy.
- Ensembles (“run all matching slots”)—left as explicit extension seams that require new dispatch strategies.
- Pattern-based selectors.
- Boundary self-vision restrictions (“anti-reflex rule”)—needs its own meta-dimension so we don’t break standard Korz guards.
- Yoneda-style identity profiling, piles/selection engines, Croquet/Syndicate replica semantics—tracked as research spikes once the kernel exists.

## Success Criteria
- Projection objects behave like regular Pharo objects from user code (`perform:withArguments:` works).
- Dispatch chooses the most specific guard given a context; ambiguity and missing-slot errors are explicit.
- GT inspectors present meaningful slices (dimensions, coordinates, slots, projections) without crashes.
- Example/tests demonstrate the subjective object story across multiple projections.

## Falsifier alignment
- **Korz-first semantics:** build the conventional unique-dispatch Korz runtime before entertaining combiners or ensembles. Future strategy hooks will host those experiments.
- **Guard usage:** keep the standard Korz practice where a guard may constrain the same dimension it binds; “boundary can’t see itself” must be modelled separately later.
- **Combiners as strategies:** any “run all slots” behaviour (meet/sum/quorum/etc.) will plug in via dispatcher policies rather than as ordinary coordinates.
- **External structures:** piles, Yoneda profiles, Croquet-style epochs/replicas only enter scope once we can map them cleanly into dimensions + coordinates; until then they remain research items.
