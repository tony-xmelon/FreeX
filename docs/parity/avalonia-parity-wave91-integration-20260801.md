# Avalonia parity Wave 91 integration

Date: 2026-08-01

## Integrated slices

- **FreeX drawing clipboard:** Avalonia copies and pastes selected charts, shapes, pictures, and
  text boxes as drawing objects through the shared `DuplicateDrawingObjectCommand`. Keyboard,
  ribbon, native-command, and context-menu routes share the behavior without replacing normal cell
  clipboard handling. Escape, Copy, and Cut clear stale object clipboard state.
- **FreeP multi-selection transforms:** a shared `CanvasTransformPreviewComposer` produces filled
  transient drawing-operation clones. WPF and Avalonia replace selected operations in painter order
  during group resize and rotation, then remove previews on commit, cancel, capture loss, and
  disposal.
- **FreeP startup lifecycle:** the late notes refresh no longer records a no-op undo command after
  document load, so a newly opened presentation remains clean. Startup dirty-state tracing is
  available through the explicit `--startup-dirty-trace` switch and remains disabled in normal
  sessions.
- **FreeW PDF effects:** shared PDF planning now carries reflection end opacity, positions, fade
  direction, scale, skew, and blur. Skia output uses true blur and directional reflection fading;
  portable output retains a deterministic six-band fallback. Skew angles are converted correctly
  from degrees before reaching Skia.
- **FreeW Backstage:** Open content is hosted in the correct tab items, Home stretches correctly,
  Save As is more compact, and Print row spacing and alignment follow the WPF authority more
  closely. Mean image deltas improved from 12.326 to 11.315 for Home, 16.872 to 14.078 for Open,
  11.405 to 11.339 for Save As, and 10.289 to 7.913 for Print; Export remained 12.282.
- **FreeW multilevel lists:** the production dialog now uses WPF control metrics and chrome, with a
  one-pixel route-specific harness width normalization. The three measured changed-pixel ratios
  improved from roughly 13.5% to 2.77%, 2.77%, and 2.92%, and all comparisons pass.
- **Integration guard:** the older FreeX Escape source contract now asserts both clipboard visual
  states, preserving marquee cancellation while covering the new drawing-object clipboard.

## Verification

- FreeX Avalonia drawing-object clipboard lane: **4/4 passed**.
- FreeX WPF clipboard authority lane: **2/2 passed**.
- FreeX integrated clipboard/marquee regression lane: **26/26 passed**.
- FreeP transform preview composer: **3/3 passed**.
- FreeP WPF canvas editing: **43/43 passed**.
- FreeP Avalonia slide canvas: **82/82 passed**.
- FreeP startup and native-picker managed workflow lane: **9/9 passed**.
- Shared PDF tests: **91/91 passed**.
- FreeW PDF export, Backstage, and multilevel-list combined lane: **50/50 passed**.
- Repository preflight: **passed**, including current generated evidence, **28/28** FreeP dialog
  panes, and **33/33** paired FreeP whole-window surfaces.
- Full Release builds passed for FreeX, FreeW, and FreeP with **0 warnings** and **0 errors**.
- Serialized default lane: **34,871 passed**, **0 failed**, and **133 skipped** across **35,004**
  tests in 19 test assemblies.
- Linux Docker family interaction lanes: **85/85 passed**: FreeX **24/24**, FreeW **37/37**, and
  FreeP **24/24**.
- FreeP native-picker physical X11 lane: **9/9 passed** with a fresh document mount and strict
  manifest validation.
- FreeP multi-selection physical X11 lane: **9/9 passed**, covering group selection, resize,
  rotation, saved geometry, undo, Escape cancellation, and capture-loss cancellation.
- The live FreeP Linux title is `Untitled — FreeP`, confirming that startup no longer introduces a
  dirty marker.

The first broad run used a 15-minute command ceiling and was interrupted while its first test host
was still attached. An isolated rerun passed all 528 FreeP Avalonia tests, and a watchdog-enabled
full run exposed one stale FreeX source assertion. After updating that assertion, the complete
35,004-test lane passed. Native-picker retries against the lane's reused Wave 90 output directory
encountered prior Save As output; the unchanged probe passed 9/9 against a fresh Wave 91 mount.

## Remaining depth

- FreeX drawing-object Cut still behaves as copy rather than moving/removing the source object.
- FreeP transform previews remain limited by renderer support for chart rotation and uncommon draw
  operations.
- FreeW Backstage is measurably closer but still has genuine raster differences on every captured
  surface.
- Portable PDF effects intentionally approximate blur, reflection gradients, and three-dimensional
  geometry where the backend cannot express the native effect directly.
