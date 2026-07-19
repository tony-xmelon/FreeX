# FreeP triggered entrance overlay playback

## Scope

WPF and Avalonia now prepare overlays for entrance and motion animations regardless of `TriggerShapeId`. Trigger-bound animations therefore retain the authored shape bitmap and can run their actual shared effect plan when the trigger is clicked, instead of falling through to the coarse whole-slide fallback.

WPF now matches Avalonia's suppression handoff: entrance/motion shapes are removed from the base canvas while their overlay plays, then restored when the storyboard completes. Exit suppression remains start-of-exit behavior, and emphasis overlays remain visible without changing the base shape's ownership.

## Verification

- WPF `SlideShowHostPolicySourceTests`: 2/2 compiling and 2/2 no-build.
- Avalonia `SlideShowHostPolicySourceTests`: 3/3 compiling and 3/3 no-build.

This is functional trigger playback coverage. Static RenderCompare does not sample interactive animation frames, so no raster percentage is claimed.
