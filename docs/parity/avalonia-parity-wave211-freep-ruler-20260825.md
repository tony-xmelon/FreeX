# Wave 211 — FreeP View Ruler

## Scope

This slice adds a real PowerPoint-style **View > Show > Ruler** toggle to
FreeP. It has no external dependency. Ink/Draw behavior and map-chart fidelity
remain outside the active parity scope.

## Change

The shared View-show state now owns the Ruler command and its checked state.
Both native slide canvases render horizontal and vertical rulers from the live
slide transform, so inch ticks follow the current zoom and letterbox position.
The stage reserves ruler thickness before fitting the slide, keeping chrome
outside editable slide content. Standalone canvases used for thumbnails and
print surfaces explicitly omit the editor-only ruler chrome.

## Evidence

The final WPF capture at
`artifacts/wave211-freep-ruler/view-ribbon-final.png` shows the selected Ruler
command plus unobstructed horizontal and vertical ruler surfaces around the
slide. The generated command inventory now reports 714 commands, all shared by
the WPF and Avalonia profiles.

## Verification

- `FreeP.App.Presentation` Release build: passed, zero warnings/errors.
- `FreeP.App.Host` Release build: passed, zero warnings/errors.
- `FreeP.App.Avalonia` Release build: passed, zero warnings/errors.
- Focused ruler, View-show, and ribbon workflow suite: 51 passed, 0 failed.
- Focused Avalonia slide-canvas suite: 89 passed, 0 failed.
- Focused WPF slide-canvas suite: 41 passed, 0 failed.
- `Generate-FreePCommandParityInventory.ps1` and `-Check`: passed.
