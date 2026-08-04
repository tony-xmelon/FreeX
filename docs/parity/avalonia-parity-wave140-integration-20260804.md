# Avalonia/WPF parity wave 140 integration

Date: 2026-08-04

## Scope

Wave 140 advanced one bounded parity residual in each application and audited the current WPF raster-capture outage:

- FreeX: tightened the Avalonia PivotTable Options Display-tab vertical rhythm against the retained WPF authority.
- FreeW: moved the missing Insert SmartArt explanatory label into the shared dialog presentation contract used by both hosts.
- FreeP: added shared Zoom frame-border color authoring, validation, native persistence, undo, and rendering to both desktop hosts.
- Infrastructure: exercised multiple WPF capture modes to determine whether first-render warmup or detached-window setup explained the zero-pixel results.

## Results

- FreeX's isolated PivotTable Options Display comparison improved from `3.6799076797%` to `2.8928129085%`, a `21.39%` relative reduction. The fresh Avalonia capture is nonblank, exact `520x500`, and exited normally. The current WPF recapture was transparent, so the retained authority remains in place.
- FreeW now presents the same Insert SmartArt guidance in both hosts: `Diagram text (one item per node - use Add/Remove to manage):`. The fresh Avalonia dialog remained nonblank at `x=14,y=18,518x294`; WPF's retained content bounds are `x=14,y=18,517x305`, leaving an honest 11-pixel font/layout geometry residual. A fresh blank WPF capture was rejected.
- FreeP Zoom frame-border color now flows through the shared model, planner, native XML persistence, undo path, and compositor. Unsupported gradient, pattern, and no-fill states remain preserved. Command coverage remains `648/648` with 110 workflow rows because this adds depth to the existing Zoom Format command.

## Verification

- Repository preflight passed, including every generated-document freshness check.
- `dotnet build FreeX.slnx --configuration Release` passed with zero warnings and zero errors.
- Focused owning tests passed `192/192`: FreeX `19`, FreeW `23`, and FreeP `150`.
- FreeX's complete Avalonia suite passed `2025/2025` in the default lane.
- The default lane executed 36,344 of 36,478 discovered tests: 36,313 passed, 31 failed, and 134 were skipped. Thirty failures reproduce the established WPF zero-pixel raster outage. The one additional FreeX clipboard-formatting failure passed immediately in isolation and is recorded as a parallel-run transient rather than a product regression.

## Evidence boundaries

The WPF raster audit tried first and second renders, dispatcher pumping, explicit arrange, HWND attachment, shown windows, software rendering, and an application loop. Every probe returned zero nontransparent pixels. A temporary image previously described as successful was independently inspected as a `560x600` single-color fully transparent bitmap with zero opaque or nonblack pixels. The first-render warmup hypothesis is therefore rejected, no WPF capture was promoted, and the current-source WPF raster outage remains the principal visual-evidence infrastructure residual.

The remaining product residuals in this wave are FreeW's font-driven SmartArt height difference and broader PowerPoint-native Zoom border theme, gradient, width, dash, and effect support.
