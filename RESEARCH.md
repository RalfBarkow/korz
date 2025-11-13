# RESEARCH

## Source material
- Korz “projection objects” papers/examples (screen, location, isColorblind) serve as the guiding mental model.
- Existing Pharo/Glamorous Toolkit inspectors establish the UI idioms we should match.

## Key insights
1. Guards are multidimensional: both selectors and parameter constraints must participate in specificity ordering.
2. Coordinates form partial orders per dimension; supporting ancestor queries is essential for dispatch.
3. Projection objects are façade views over the slot space—identity is contextual, not intrinsic.
4. GT integration should emphasize browsing within the “sea of slots,” allowing users to pivot dimensions quickly.

## Falsifier's report takeaways
- Anti-reflex “boundary can’t see itself” rules clash with vanilla Korz; keep them as future meta-dimensions or analyses, not baseline semantics.
- Running “all matching slots” (meet/sum/quorum/fixpoint) requires an explicit dispatcher strategy layer; a naive `combiner` coordinate would violate Korz’s unique-slot contract.
- Graph/pile/Yoneda/Croquet structures need concrete encodings as slots + coordinates; until we prove that mapping, they remain experiments rather than scope items.
- Any claims about quick implementation must be backed by real slot-space code plus tests—documentation now reflects that reality.

## Open questions / to-verify
- How should raw Smalltalk values vs. coordinates coexist in slot contents? (May need a wrapper protocol.)
- What is the preferred strategy for ambiguity: error, choose-arbitrary, or user-provided handler?
- Are there existing Korz implementations in Pharo that we should interop with or differentiate from?
