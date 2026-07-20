# WPF Live Floating-Anchor Geometry

## Scope

The WPF floating-object overlay previously estimated each paragraph anchor
from character counts before placing the overlay canvas object. That estimate
diverged from the already laid-out document whenever preceding paragraphs had
wrapping, floating reservations, or mixed object content. The text flow was
correct, but its page-relative floating objects were not using the same
coordinate system.

## Change

`DocumentView.SyncFloatingObjectsCanvas` now reads the paragraph's live
`TextPointer.GetCharacterRect` position and normalizes it against the live
document origin before asking the shared placement planner for the object
rectangle. The existing leading-content estimate remains the fallback while
WPF is arranging and geometry cannot be queried.

This preserves source placement semantics and changes no shape, image, chart,
SmartArt, or WordArt offsets by fixture-specific calibration.

## Cached Word Evidence

The persistent matching Word COM baseline and candidate composite are 816 x
1056. The candidate used a freshly rebuilt Release fidelity-renderer artifact.

| Fixture | Region | Before | After |
| --- | --- | ---: | ---: |
| `drawing-objects-complex` | whole page | 7.7540% | 7.5984% |
| `drawing-objects-complex` | floating-object region `(90,195)-(730,735)` | 12.7188% | 12.3309% |
| `object-format-position-size-style` | whole page | 6.3657% | 6.1948% |
| `object-format-position-size-style` | floating-object region `(85,215)-(655,545)` | 17.7762% | 16.9931% |

`f2-01-float-wrap` is an exact paired control: candidate and prior WPF PNG
SHA-256 are both
`0F42C84C4431434927A8AAFB6BD47D82B3768832909EAAF1A2F1E5B6BB93B4D4`.

## Verification

- `dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
  passed with 0 warnings and 0 errors.
- Focused `FloatingOverlay` host contracts passed 3/3 with `--no-build`.
- The rebuilt composite emitted all target and control images from the cached
  source documents; no competing Word COM export was started.

## Process Note

When an overlay is anchored to document content, use the layout engine's
actual `TextPointer` geometry rather than a model-side character estimate.
Keep an estimate only as a transient layout fallback, then gate the shared
coordinate correction against multiple object families and an exact control.
