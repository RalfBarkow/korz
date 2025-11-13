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
- Ensembles (“run all matching slots”)—only leave extension seams.
- Pattern-based selectors.

## Success Criteria
- Projection objects behave like regular Pharo objects from user code (`perform:withArguments:` works).
- Dispatch chooses the most specific guard given a context; ambiguity and missing-slot errors are explicit.
- GT inspectors present meaningful slices (dimensions, coordinates, slots, projections) without crashes.
- Example/tests demonstrate the subjective object story across multiple projections.
