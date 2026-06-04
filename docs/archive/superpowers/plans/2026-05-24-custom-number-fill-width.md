# Custom Number Fill Width

## Goal

Improve custom number format layout fidelity by honoring Excel `*` fill directives with the repeated fill character when a target display width is available.

## Steps

1. Add a regression test for a non-space fill directive such as `0*-` with a target width.
2. Verify it fails because the current target-width path left-pads with spaces.
3. Extend target-width fill handling to repeat the fill character at the directive location when possible, keeping existing accounting-space behavior intact.
4. Update architecture and command parity docs for active fill-character expansion.
5. Run focused number formatter tests and a full build, then commit and sync.
