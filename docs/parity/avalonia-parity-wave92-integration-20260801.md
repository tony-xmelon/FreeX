# Avalonia parity Wave 92 integration

Date: 2026-08-01

## Integrated slices

- **FreeX drawing-object Cut:** charts, shapes, pictures, and text boxes now use a true transactional
  Cut/Move command in both WPF and Avalonia. Keyboard, ribbon/native command, and drawing-object
  context-menu routes share the behavior. Same-sheet and cross-sheet protection checks run before
  mutation, Cut preserves object coordinates, Copy retains the visible 12-pixel cascade, failed or
  stale pastes retain the pending Cut, Escape cancels it, and Undo restores the original object.
- **FreeP transform previews:** chart rotation now flows through the neutral drawing-operation
  compositor and both WPF and Avalonia renderers, extending the shared multi-selection preview path.
- **FreeW portable PDF effects:** the portable writer now approximates blur with symmetric weighted
  stamps and reflection with 12 directional, bounded fade bands under the inverse transform. The
  shared and FreeW PDF lanes cover the new output.
- **FreeW Page Setup:** the Avalonia dialog now follows WPF dimensions, typography, field widths,
  action sizing, field order, checkbox grouping, and initial-tab lifecycle.
- **FreeW Backstage:** Open tab ownership/alignment, compact search and Save As inputs, and persistent
  pane scrolling now track the WPF authority more closely. All five paired rows remain honest visual
  mismatches, but changed-pixel ratios improved to 14.029% Home, 13.543% Export, 18.497% Open,
  9.829% Save As, and 8.586% Print.
- **Shared ribbon popups:** WPF popup behavior moved into one adapter, while WPF and Avalonia now
  share chrome, root edge placement, nested focus, enabled-item traversal, Right-to-open,
  Left/Escape dismissal, and owner-focus restoration for regular and collapsed-group menus.

## Verification

- FreeX Avalonia object clipboard: **32/32 passed**.
- FreeX WPF object clipboard: **3/3 passed**.
- FreeX worksheet context-menu planner: **61/61 passed**.
- Shared ribbon UI lane: **40/40 passed**.
- Shared portable PDF lane: **92/92 passed**; FreeW PDF export: **13/13 passed**.
- FreeW Page Setup family/chrome: **48/48 passed**; planner: **6/6 passed**; WPF authority:
  **3/3 passed**.
- FreeW Backstage: **34/34 passed**.
- FreeP presentation/compositor: **122/122 passed**; Avalonia slide canvas: **83/83 passed**.
- Repository preflight: **passed**, including **28/28** FreeP dialog/pane and **33/33** paired
  FreeP whole-window evidence checks.
- Full Release builds passed for FreeX, FreeW, and FreeP with **0 warnings** and **0 errors**.
- Serialized default lane: **35,040 passed**, **0 failed**, and **133 skipped** across **35,173**
  tests in 19 test assemblies.
- Linux Docker family interaction lanes: **85/85 passed**: FreeX **24/24**, FreeW **37/37**, and
  FreeP **24/24**. Every manifest contract passed and every harness-owned container stopped.
- Dedicated FreeP multi-selection physical X11 lane: **9/9 passed**, covering selection, resize,
  rotation, saved geometry, Undo, Escape cancellation, and capture-loss cancellation.

The first preflight correctly reported the FreeP whole-window evidence fingerprint as stale after
the shared ribbon source changed. Regenerating the manifest resolved the drift, and the complete
preflight then passed. No machine-wide process cleanup or build-server shutdown was performed, so
the unrelated active Claude build/review session remained untouched.

## Remaining depth

- FreeW Backstage still has native Avalonia template, text rasterization, long-row clipping, action
  metadata, and native-printing differences across all five paired surfaces.
- Portable PDF bevel/three-dimensional effects remain bounded approximations; native toolkit
  behavior still owns nested submenu edge placement.
- FreeP chart rotation is covered by managed renderer tests, while the dedicated physical transform
  lane continues to use its established two-shape fixture.
- Broader dialog and visual raster alignment remains ongoing even though the integrated functional
  and physical contracts are green.
