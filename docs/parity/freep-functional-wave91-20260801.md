# FreeP functional parity Wave 91

Date: 2026-08-01

## Selected gap

The shared animation model already accepts arbitrary cubic motion paths, but the
authoring gallery exposed only a small subset of PowerPoint's standard arc
directions. Wave 91 adds the missing mirrored and vertical arc routes without
changing playback or raster rendering policy.

## Closure

`Arc Left`, `Arc Up`, and `Arc Down` are now shared animation command plans. WPF
and Avalonia receive the commands through their existing generated ribbon
profiles, with localized labels, key tips, and effects icons. Each route creates
an undoable `p:animMotion` model object using the existing writer and playback
path. Arc Left is carried forward from the preceding isolated slice.

## Verification

```text
PresentationAnimationCommandPlannerTests: 75 passed, 0 failed
FreePRibbonDefinitionProfileTests: 23 passed, 0 failed
RibbonTransitionsAnimationsTests: 119 passed, 0 failed
Avalonia Ribbon_motion_command_creates_motion_path_animation: 1 passed, 0 failed
FreeP command inventory: 584 total, 584 shared, 0 actionable gaps
Generated documentation checks: passed
```

This is functional authoring and package-path parity evidence; it makes no new
PowerPoint-authoritative raster claim.

## Residuals

PowerPoint-authoritative animation-pane visuals and advanced effect playback
remain deferred, as do in-place OLE hosting, live hardware recording, broader
SmartArt/OMML/media depth, and COM-backed export baselines.
