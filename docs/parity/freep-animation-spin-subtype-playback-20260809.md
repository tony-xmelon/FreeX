# FreeP Spin animation subtype playback - 2026-08-09

The animation pane already exposed and persisted PowerPoint's Spin effect
choices (`quarterSpin`, `halfSpin`, `fullSpin`, and `twoSpins`), but the shared
playback planner treated every Spin as one 360-degree turn. The planner now
maps those authored subtypes to 90, 180, 360, and 720 degrees respectively;
unknown or omitted tokens retain the 360-degree compatibility fallback.

Because WPF and Avalonia both consume `SlideShowPlaybackPlanner`'s rotation
value, the fix applies to both hosts without renderer-specific timing logic.
This is a functional playback correction; it makes no visual-baseline claim.

Verification:

- Shared playback planner tests cover all four authored values and the unknown
  token fallback.
- WPF and Avalonia host consumers continue to use the shared rotation plan.
