# Review region coverage

What the rolling code-review program (rounds 176+) has and has not aimed a dedicated lens at.
This exists because "keep reviewing until the codebase is exhausted" is unfalsifiable without an
accounting of what has actually been looked at. Update it at the end of each round.

A region counts as **covered** only when a lens targeted it *by name* and reported (findings or a
considered empty answer). A region touched incidentally by a cross-cutting lens does not count.

Cross-cutting lenses used so far — meta (audits the previous round's own commit), undo/redo,
concurrency, input edges, localization/culture, state-after-failure, selection/caret, clipboard,
formatting fidelity, test integrity, resource lifetime, IO round-trip, accessibility, robustness
against malformed input, and a rotating numbered sweep class (108-118).

## Covered

| Region | Files | Round | Outcome |
|---|---:|---|---|
| shared/Free.Shared.AppServices | 121 | r181 shared-tier | Recent-list UI-thread block (remedy incomplete, see below) |
| src/FreeX.Core.IO | 396 | r181 xlsx-io | VML shape-id collision with cell comments |
| src/FreeX.Core.Formula + Core.Calc | 154 | r177, r181 | empty both times |
| freew/FreeW.Core.IO | 33 | r181 untrusted-input | two uncatchable StackOverflow crashes |
| freep/* domain (slides/masters/layouts) | ~530 | r181 freep-domain | placeholder Idx never allocated |
| print / export / PDF / XPS | — | r181 print-export | Insert > Shapes never printed (open) |
| on-screen layout + rendering | — | r181 render-layout | chart render cache never invalidates (open) |
| accessibility (both shells, 3 apps) | — | r181 accessibility | content controls not keyboard-focusable |
| FreeW find/replace + editing surface | — | r177-r181 | many; the most-worked area of the program |

## Not yet covered by a dedicated lens

Ordered by size. These are the honest answer to "what remains".

| Region | Files | Why it is worth its own lens |
|---|---:|---|
| src/FreeX.App.Presentation | 454 | Largest production project in the repo; only ever reached incidentally. |
| freep/FreeP.App.Presentation | 364 | Second largest; the FreeP lens covered the domain model, not this layer. |
| freew/FreeW.App.Presentation | 318 | Same: the editing surface was reviewed, the rest of the layer was not. |
| src/FreeX.App.Host | 291 | The WPF shell. Reviewed only where a cross-cutting lens landed. |
| src/FreeX.Core.Commands | 251 | The undo lens covered command *shape*; the command bodies were not swept. |
| src/FreeX.App.Services | 197 | Planner/options/export services. |
| src/FreeX.App.Avalonia | 169 | The Linux/macOS shell. |
| freew/FreeW.App.Host + App.Avalonia | 212 | Beyond find/replace and paste. |
| shared/Free.Shared.Shell{,.Wpf,.Avalonia} | 121 | Chrome/backstage shared across all three apps. |
| shared/Free.Shared.Ribbon{,.Wpf,.Avalonia} | 71 | Ribbon definition + rendering tier. |
| src/FreeX.App.UI | 74 | Grid rendering; the chart-cache finding came from here but the region was not swept. |
| shared/Free.Shared.Opc / IO / Pdf / Drawing / Theme | 87 | Package, PDF and drawing primitives shared by all three apps. |
| freep/FreeP.App.Recording{,.Windows} | 24 | Slide-show recording: audio/video capture, never reviewed. |
| Ribbon.Definitions (3 apps) | 30 | Declarative command surface. |

## Concern areas never given a lens

- Performance and algorithmic complexity (a dense-range-scan hang class exists in this codebase's
  history, so this is not hypothetical).
- Memory retention / leaks: event handlers and caches that outlive the document or window.
- Serialization formats beyond XLSX/DOCX/ODT: CSV, DIF, SLK, fxl, RTF, HTML.
- Security boundaries: external content (OLE payloads, linked images, hyperlinks), path handling.
- Cancellation and progress: long operations that cannot be cancelled or report wrong progress.
- Update/installer and crash-recovery flows.
- Cross-app consistency of shared *behaviour* (as opposed to shared code).

## Known-open findings, with the reason each is still open

1. **Insert > Shapes are never printed, exported or previewed.** `WorksheetPrintDrawingLayerPlan`
   has no `Shapes` field and `sheet.DrawingShapes` is read nowhere in the print pipeline. Needs a
   geometry planner plus changes to the planner, render-model builder, preview builder, WPF renderer
   and PDF/XPS export.
2. **WPF chart render cache never invalidates on appearance edits.** Keyed on the `ChartModel`
   reference plus a data-only fingerprint. `ChartModel` has 328 settable properties, so a
   hand-enumerated appearance fingerprint would rot; it needs a central invalidation seam.
3. **Recent-list probe blocks the UI thread in FreeW/FreeP.** The off-thread cache exists and now
   lives in `Free.Shared.AppServices`, but adopting it requires the four FreeW/FreeP shells to wire
   its `onProbed` refresh, as both FreeX shells already do. Without that it trades a freeze for a
   dead entry that never disappears — two existing tests correctly refuse the half-fix.
