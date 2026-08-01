# Avalonia parity Wave 90 integration

Date: 2026-08-01

## Integrated slices

- **FreeX:** formula point mode now routes selections from a second workbook window to the
  workbook that owns the edit in WPF and Avalonia. Replace, disjoint append, drag extension,
  source-window selection chrome, F4 reference cycling, Enter commit, and Escape cancel preserve
  external workbook and sheet qualifiers.
- **FreeW PDF:** grouped drawing export is recursive and preserves nested transforms, clipping,
  z-order, fills, patterns, outlines, text, images, charts, SmartArt, and WordArt. Shape and
  WordArt shadow, glow, soft-edge, reflection, and bevel cues now use shared PDF effect operations
  in the portable and Skia writers for grouped and ungrouped objects.
- **FreeP:** stale WPF canvas gesture handlers are disposed when editing sessions are rewired,
  preventing duplicate input subscriptions and orphaned adorners.
- **Shared ribbon:** nested popup interaction and chrome are aligned across WPF and Avalonia,
  including enabled-item traversal, Left/Escape dismissal, owner focus restoration, and
  per-monitor WPF work-area placement.
- **Shared dialogs:** compact Avalonia dialogs use antialiased text while preserving explicit local
  typography. Legal Notices keeps a persistent long-document scrollbar and neutral default-button
  border. The measured six-state average changed-pixel ratio improved from 16.0202% to 15.8987%.
- **FreeW Backstage:** shared scrolling, WPF typography metrics, Save As width, and Print alignment
  reduced mean image deltas for Home 15.438 to 12.326, Export 14.826 to 12.282, Open 17.979 to
  16.872, Save As 12.643 to 11.405, and Print 10.675 to 10.289. These remain honest mismatches.
- **Physical evidence:** a dedicated FreeP X11 lane physically drives native Open and Save As,
  validates PPTX filter/extension and package contents, preserves an overwrite collision, bounds an
  unwritable-target error, cancels both pickers with Escape, and proves owner-focus restoration.

## Focused verification

- FreeX cross-workbook resolver tests: **5/5 passed**.
- FreeX WPF cross-workbook window tests: **2/2 passed**.
- FreeX Avalonia cross-workbook window tests: **2/2 passed**.
- Shared PDF tests after effect integration: **88/88 passed**.
- FreeW Avalonia PDF export tests: **13/13 passed**.
- FreeW Backstage and Legal Notices integrated tests: **34/34 passed**.
- Shared ribbon lane: **39/39 passed**.
- FreeP WPF canvas-editing lane: **42/42 passed**.
- FreeP native-picker physical X11 lane: **9/9 passed**, strict manifest contract passed.
- FreeP startup attached-window lifecycle regression: **1/1 passed**.
- Repository preflight: **passed**, including current generated evidence and **33/33** paired FreeP
  whole-window surfaces.

## Remaining depth

- Full Release build, serialized default test lane, and Linux family interaction lanes are pending
  for this integration tip.
- FreeW PDF effects intentionally use visible portable/vector fallbacks rather than native blur,
  full reflection fade/skew gradients, or true 3-D bevel/material geometry.
- FreeW Backstage and Legal Notices improved measurably but remain genuine raster mismatches.
- The physical FreeP run exposed a startup-document dirty marker that does not reproduce after
  `Show()` and render/background dispatcher settling in the attached-window regression. No masking
  workaround was added; the Docker-only residual remains open pending exact dirty-transition logs.
