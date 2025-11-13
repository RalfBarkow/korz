# RESEARCH

## Source material
- Korz “projection objects” papers/examples (screen, location, isColorblind) serve as the guiding mental model.
- Existing Pharo/Glamorous Toolkit inspectors establish the UI idioms we should match.

## Key insights
1. Guards are multidimensional: both selectors and parameter constraints must participate in specificity ordering.
2. Coordinates form partial orders per dimension; supporting ancestor queries is essential for dispatch.
3. Projection objects are façade views over the slot space—identity is contextual, not intrinsic.
4. GT integration should emphasize browsing within the “sea of slots,” allowing users to pivot dimensions quickly.

## Open questions / to-verify
- How should raw Smalltalk values vs. coordinates coexist in slot contents? (May need a wrapper protocol.)
- What is the preferred strategy for ambiguity: error, choose-arbitrary, or user-provided handler?
- Are there existing Korz implementations in Pharo that we should interop with or differentiate from?
