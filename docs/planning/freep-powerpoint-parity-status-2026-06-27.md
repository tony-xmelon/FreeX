# FreeP PowerPoint Parity Status - Updated 2026-07-01

Status owner: FreeP parity orchestration. This report supersedes the 2026-06-27 pre-dedup FreeP snapshot. It is still a worker handoff and implementation plan, not a claim of full Microsoft PowerPoint parity.

Branch/worktree context for this update: `codex/freep-parity-report-refresh-20260701` at `origin/main` commit `296e71014b99b9743f50a22984db97cf04e2e809`. The update is docs-only and is based on local inspection plus the 2026-07-01 FreeP parity implementation wave.

## Current Evidence

- Primary repo root: `C:\Users\anton\OneDrive\Documents\FreeX\FreeX`.
- `main` was clean and synced with `origin/main` at `296e71014` before this report branch was created.
- `AGENTS.md` still requires isolated worktrees, no feature edits in `main`, frequent sync, subagents for independent work, and concrete validation before integration.
- `PowerPoint.Application` COM is not registered on this machine, so PowerPoint-authoritative visual baselines cannot be generated locally.
- The repo-wide parity scope at `docs/parity/2026-06-27-avalonia-wpf-parity-scope.md` has already been refreshed for the large dedup wave.

## 2026-07-01 Integration Checkpoint

The first post-dedup FreeP parity implementation wave is integrated on `main` through `296e71014`. It closed the initial evidence and shared-planning gates that were blocking reliable WPF/Avalonia parity work:

- Added a generated FreeP WPF/Avalonia command inventory at `docs/parity/freep-command-parity-inventory.md` and `.json`.
- Added 20-deck PPTX corpus retention contract tests for package-preservation evidence.
- Fixed `tools/FreeP.RenderCompare --avalonia-compare` trust reporting so PowerPoint export failure is not reported as success, and added corpus summary output.
- Moved chart legend planning, text render route planning, and canvas drag reduction into shared FreeP presentation-layer planners consumed by WPF and Avalonia.
- Expanded the Avalonia ribbon profile from the initial small surface to 38 shared command ids. The generated command inventory currently reports 94 total commands, 38 shared, 5 explicit Avalonia gaps, 43 known deferred commands, 6 platform-only commands, and 2 command-id aliases.

PowerPoint baseline anchors used for current scope: Microsoft documents PowerPoint File > Export paths including PDF, video, and handouts, Presenter View with current/next slide and notes, recording narration/timings, print layouts for slides/handouts/notes, and modern comments. Those remain parity targets for FreeP:

- `https://support.microsoft.com/en-us/powerpoint/export-a-presentation`
- `https://support.microsoft.com/en-us/powerpoint/training/save-powerpoint-presentations-as-pdf-files`
- `https://support.microsoft.com/en-us/powerpoint/turn-your-presentation-into-a-video`
- `https://support.microsoft.com/en-us/powerpoint/training/use-presenter-view-in-powerpoint`
- `https://support.microsoft.com/en-us/powerpoint/training/record-a-slide-show-with-narration-and-slide-timings`
- `https://support.microsoft.com/en-us/powerpoint/training/print-your-powerpoint-slides-handouts-or-notes`
- `https://support.microsoft.com/en-us/powerpoint/modern-comments-in-powerpoint`

## Current Implementation Reality

FreeP is now a real shared-first implementation, not a stub shell. Several gaps from the June 27 report are closed or materially changed.

| Area | Current repo evidence | Current status |
| --- | --- | --- |
| Solution map | `FreeP.slnx` includes Core.Model, Core.IO, App.Presentation, WPF host/rendering/tests, Avalonia host/rendering/tests, ribbon definitions, localization, and `tools/FreeP.RenderCompare`. | Dedicated FreeP solution exists. |
| Shared model/IO | `freep/FreeP.Core.Model/**`, `freep/FreeP.Core.IO/**`, `shared/Free.Shared.Opc`, `shared/Free.Shared.Drawing`, `shared/Free.Shared.Pdf`. | PPTX model, reader/writer, package snapshot, OPC helpers, charts, SmartArt, comments, notes, OLE/math, transitions, and PDF plumbing exist. |
| Shared presentation layer | `freep/FreeP.App.Presentation/**`. | App-neutral planners/controllers now cover persistence, file dialogs, slide composition, text layout, chart primitives, effects, picture color effects, gestures, hit testing, slide pane policy, slideshow host/playback, object insertion, dialogs, and SmartArt layout. |
| Shared ribbon definitions | `freep/FreeP.Ribbon.Definitions/**`, `freep/FreeP.Ribbon.Definitions.Tests/**`, `docs/parity/freep-command-parity-inventory.*`. | WPF and Avalonia ribbon profiles are single-sourced with generated capability deltas. The current inventory reports 94 total commands, 38 shared, and 5 explicit Avalonia gaps. |
| WPF app | `freep/FreeP.App.Host/**`, `freep/FreeP.App.Rendering.Wpf/**`, `freep/FreeP.App.Host.Tests/**`. | WPF is mostly a host/renderer adapter over shared policy, but still has richer command, slide pane, dialog, and editing coverage than Avalonia. |
| Avalonia app | `freep/FreeP.App.Avalonia/**`, `freep/FreeP.App.Rendering.Avalonia/**`, `freep/FreeP.App.Avalonia.Tests/**`, `freep/FreeP.App.Rendering.Avalonia.Tests/**`. | Cross-platform shell and renderer exist. Avalonia consumes shared file workflow, ribbon definitions, slide pane planning, and rendering planners. Command breadth has improved; remaining explicit gaps are Find, Replace, Layout, Hyperlink, and Remove Link, with larger Design/Transitions/Animations slices intentionally classified as deferred. |
| PPTX lifecycle | `freep/FreeP.App.Presentation/PresentationFilePersistenceWorkflow.cs`, `freep/FreeP.App.Host/FileCommands.cs`, `shared/Free.Shared.Shell.Avalonia/SisterAvaloniaFileCommandWorkflow.cs`. | `.pptx` is now the default lifecycle path; `.fxp` remains legacy-compatible. The old WPF `.pptx` lifecycle gap is no longer a foundational blocker. |
| Package retention | `freep/FreeP.Core.Model/PptxPackageSnapshot.cs`, `PptxPackageReader.cs`, `PptxPackageWriter.cs`, `freep/FreeP.App.Host.Tests/PptxPackageRetentionTests.cs`. | Preservation machinery exists and the 20 tracked corpus decks now have a retention contract test. It still needs broader semantic proof after writer-owned edits. |
| Render comparison | `tools/FreeP.RenderCompare/**`, `tools/FreeP.RenderCompare.Tests/**`, `tools/FreeP.RenderCompare/corpus/*.pptx`, `tools/FreeP.RenderCompare/PixelDiversity.cs`. | Harness supports WPF, Avalonia, PowerPoint, diff, pixel-diversity guards, explicit COM-unavailable reporting, and full-corpus summaries. Local PowerPoint COM is unavailable, so authoritative references for decks 06-20 still need another machine. |

## Shared-First Boundary

Future parity work should start in shared or neutral code unless the difference is genuinely platform API glue.

| Layer | Owns | Must not own |
| --- | --- | --- |
| `FreeP.Core.Model` | Presentation semantics, shapes, text, charts, SmartArt, transitions, comments, notes, OLE/math, package snapshot data. | WPF/Avalonia controls, dialogs, input events, pixel drawing APIs. |
| `FreeP.Core.IO` | PPTX/FXP/PDF package semantics, PresentationML read/write, preserved parts/rels/content types, export serialization. | Host lifecycle prompts, renderer-specific drawing, native file dialogs. |
| `FreeP.App.Presentation` | Command planners, file persistence workflow, dialog policy, slide pane policy, slideshow/presenter models, render plans, gesture reducers, text/chart/effects planning. | Platform controls, WPF dependency properties, Avalonia controls, native windows. |
| `FreeP.Ribbon.Definitions` | Ribbon tabs/groups/controls, command ids, labels/keytips, WPF/Avalonia capability profiles. | Command implementation bodies and host widget construction. |
| WPF host/rendering | Owner windows, native dialogs, WPF focus/UIA, WPF `DrawingContext`/`RenderTargetBitmap`, media element, keyboard/mouse adapter, command binding to shared planners. | PowerPoint behavior decisions or duplicated render math. |
| Avalonia host/rendering | Cross-platform windows/dialogs, file pickers, Avalonia controls, Skia/Avalonia drawing, pointer/keyboard adapter, headless smoke plumbing. | PowerPoint behavior decisions or duplicated render math. |

## Remaining PowerPoint Parity Gaps

These are the current gaps after the large dedup effort. They are ordered by what should unblock the most reliable implementation work.

| Gap | Why it matters | Shared-first owner | Thin renderer/host owner | Evidence/gates |
| --- | --- | --- | --- | --- |
| FreeP WPF-vs-Avalonia command matrix | The generated matrix now exists and is the source of truth for command-surface work. Current state: 94 total, 38 shared, 5 explicit Avalonia gaps, 43 known deferred, 6 platform-only, 2 command-id aliases. | Keep `tools/Generate-FreePCommandParityInventory.ps1` and generated docs current as command slices land. | WPF/Avalonia only classify adapter-only or platform-only commands. | `tools/Test-GeneratedDocs.ps1`; `FreePRibbonDefinitionProfileTests.cs`. |
| Ribbon depth and stubs | The first Avalonia Home/Insert command wave landed, but Design, Transitions, Animations, Review/View/Accessibility/Recording, layout controls, and timing controls remain incomplete or deferred. | Shared ribbon definitions, command planners, layout/timing/animation models in `FreeP.App.Presentation`. | Host adapters render galleries, combo boxes, and dialogs. | Command inventory deltas; `RibbonEditorCompleteness5BTests.cs`; `RibbonTransitionsAnimationsTests.cs`; new stub-failure tests. |
| Render harness references | Pixel-diversity guards and trust reporting are in place. Only decks 01-05 have tracked PowerPoint PNG refs; decks 06-20 lack refs because local PowerPoint COM is unavailable. | `tools/FreeP.RenderCompare` reference freshness checks, corpus manifest, full-corpus summary. | WPF/Avalonia renderers only provide images. | Run refs on a PowerPoint COM machine; compare all 20 decks. |
| Package fidelity corpus contract | The 20 tracked decks now have a package-retention contract, but semantic edit coverage is still thin for charts, SmartArt, embedded workbooks, notes, comments, media, custom XML, and view/print settings. | `FreeP.Core.IO` package classification and writer merge rules; shared OPC helpers stay generic. | Hosts do not own package semantics. | Expand corpus open-save-reopen tests with targeted ZIP/OpenXML assertions after writer-owned edits. |
| Renderer orchestration duplication | Chart legend planning, text route planning, and drag reduction are now shared. Deeper chart/text/effects sequencing, axis/label realization, placeholder inheritance, and edit-state planning still need shared-core work. | Continue moving chart scene plans, text route decisions, and gesture/edit reducers into `FreeP.App.Presentation`. | Renderers map plans to WPF/Avalonia primitives. | `RendererNeutralDedupPlannerTests.cs`; `ChartRenderPlannerTests.cs`; `TextLayoutPlannerTests.cs`; `CanvasGesturePlannerTests.cs`; render tests. |
| Text and WordArt fidelity | PowerPoint parity requires better coverage for text metrics, bullets, autofit, columns, vertical text, placeholders, tabs, run effects, theme/default fonts, and WordArt. | `TextLayoutPlanner`, model/IO text defaults, placeholder inheritance, WordArt/warp planning. | Platform font measurement/drawing callbacks. | `BulletsAutofitTests.cs`; `WordArtTests.cs`; `TextColumnsGradOutlineTests.cs`; PowerPoint-backed deck refs. |
| Charts fidelity | Chart read/write and primitive planning exist, but PowerPoint chart layout, axes, labels, series styles, embedded workbook/caches, and type-specific visuals remain high risk. | `ChartShape`, `PptxChartReader/Writer`, `ChartRenderPlanner`, package retention. | Draw primitives only. | `ChartDataCommandTests.cs`; `ChartRenderPlannerTests.cs`; `ChartTests.cs`; `ChartDataLabelsTests.cs`; corpus decks 06, 18, 19. |
| SmartArt and modern object fidelity | SmartArt parsing/layout/fallback exists, but live SmartArt data/style/color parts and editing/rendering are not PowerPoint-complete. Modern/OLE/math objects still rely on fallback previews or placeholders. | Core model/IO package semantics, `SmartArtLayoutEngine`, modern object fallback policy. | Render previews/placeholders only. | `SmartArtTests.cs`; `SmartArtLayoutTests.cs`; `ModernObjectsRoundTripTests.cs`; `OleMathRoundTripTests.cs`; corpus deck 09/14. |
| Effects, media, connectors, and pictures | Effects/3D/crop/motion-path support is modeled, but visual parity needs PowerPoint-backed evidence and more shared planning where renderers still diverge. Avalonia slideshow sound is deferred/no-op. | Shared effects/media/connector/picture planners and PresentationML IO. | Platform media playback, image decoding, and drawing. | `PictureCropEffectsTests.cs`; `MotionPathTriggerTests.cs`; `Bevel3dTests.cs`; render corpus decks 07, 08, 10, 11, 12, 15, 16. |
| PDF/export/print/backstage | PowerPoint supports File > Export to PDF/video/handouts and print layouts for slides/handouts/notes. FreeP `PresentationPdfExporter` is explicitly text-only/limited today. Backstage is deduped but shallow. | Shared export/backstage/print planners; `PresentationPdfExporter` should consume compositor/draw ops over time. | Native print dialogs, owner windows, platform file pickers. | `PresentationPdfExporterTests.cs`; new export/print/backstage tests; PDF/render inspection. |
| Slide pane and editing parity | WPF has richer slide pane context menus/drag reorder and table-cell editor. Avalonia still has a simpler list surface and no table-cell editor equivalent. | `SlidePanePlanner`, editing/session/table-cell planners, gesture reducer. | WPF/Avalonia list/control realization and input wiring. | `SlidePanePolicySourceGuardTests.cs`; `SlidePaneTests.cs`; new Avalonia slide-pane/table-cell tests. |
| Slideshow and presenter workflows | Shared slideshow playback exists, but PowerPoint-grade Presenter View, monitor selection, notes/current/next slide, rehearse/record timings, narration, laser/pen/highlighter, subtitles, and custom shows remain missing or shallow. | Shared slideshow/presenter/timing/recording/ink models and planners. | Fullscreen windows, monitor APIs, media element, cursor/input capture. | `SlideShowHostPlannerTests.cs`; `SlideShowPlaybackPlannerTests.cs`; `SlideShowTests.cs`; new presenter/recording tests. |
| Comments, accessibility, proofing, and alt text | PowerPoint includes modern comments, accessibility/alt text workflows, proofing, and review surfaces. FreeP has comment model pieces but not full UI/workflow parity. | Comments/review/accessibility planners, model/IO for comments and alt text. | Pane/dialog realization and focus/UIA. | `SectionsCommentsTests.cs`; new modern comments/accessibility/alt-text matrix and UI tests. |

## Implementation Plan

Use small, isolated linked worktrees. Each worker should start from current `origin/main`, preserve unrelated work, and report exact validation. Do not put feature semantics directly in WPF or Avalonia host files when a shared planner/model can own them.

### Phase 0 - Evidence Gate First

Goal: make parity measurable before widening feature work. The first three evidence items are now complete on `main`; PowerPoint reference generation remains blocked on this machine by missing PowerPoint COM registration.

1. Done: fix `tools/FreeP.RenderCompare --avalonia-compare` so PowerPoint export failure returns failure.
2. Done: add machine prerequisite output that clearly separates "PowerPoint COM unavailable" from "FreeP parity failed".
3. Done: add a corpus manifest/full-corpus summary for the 20 tracked decks.
4. Generate missing PowerPoint reference PNGs for decks 06-20 on a machine with PowerPoint COM installed.
5. Done: add a generated FreeP WPF-vs-Avalonia command inventory modeled after the FreeX parity inventory.

### Phase 1 - Shared Planning Cleanup

Goal: remove the remaining behavior duplication before adding large parity surfaces. The first shared chart/text/gesture slices are complete; the remaining work is deeper fidelity and workflow planning, not the initial extraction.

1. Done: move chart legend scene orchestration into `ChartRenderPlanner`, leaving renderers as primitive painters for that route.
2. Done: move first text render route decisions into `TextLayoutPlanner`.
3. Done: move canvas drag state reduction into `CanvasGesturePlanner`, leaving event capture and cursor APIs platform-local.
4. Continue expanding source guards so WPF/Avalonia cannot reintroduce duplicated chart/text/gesture math.

### Phase 2 - Command And Workflow Breadth

Goal: close visible WPF/Avalonia command gaps while keeping semantics shared.

1. Done: add the generated FreeP command matrix and classify gaps as shared, explicit Avalonia gaps, known deferred, platform-only, or command-id aliases.
2. In progress: expand Avalonia ribbon profile by high-value groups. Home clipboard/font/arrange and Insert shapes/tables/charts are shared; Find, Replace, Layout, Hyperlink, and Remove Link are the remaining explicit Avalonia gaps.
3. Replace WPF stubs for layout and timing controls with shared planners before exposing the same commands in Avalonia.
4. Add shared backstage/export descriptors before adding platform panes.

### Phase 3 - Visual Fidelity Waves

Goal: reduce measured PowerPoint diff one deck family at a time.

1. Text wave: decks 03, 13, 16, 17, 20.
2. Effects/pictures/custom geometry wave: decks 07, 08, 10, 11, 12, 15.
3. Chart wave: decks 06, 18, 19.
4. SmartArt/modern object wave: decks 09, 14 plus OLE/math fixtures.
5. Each wave must include shared planner/model/IO work first, WPF and Avalonia thin renderer updates second, and render-compare evidence last.

### Phase 4 - Presentation Workflows

Goal: close PowerPoint workflows beyond static slide editing.

1. Shared presenter model: current/next slide, notes, timer, monitor selection, custom shows.
2. Shared recording/timing/narration model and persistence.
3. Shared comments/review/accessibility/alt-text workflow planning.
4. Thin WPF/Avalonia panes/windows for presenter, comments, accessibility, and alt text.

### Phase 5 - Export, Print, And Backstage

Goal: graduate from text-only export to PowerPoint-shaped output workflows.

1. Promote `PresentationPdfExporter` toward compositor/draw-op-backed slide export.
2. Add export descriptors for PDF, video placeholder/status, image export, and handouts where feasible.
3. Add print layout planning for slides, notes pages, and handouts.
4. Keep native print/file dialogs platform-specific.

## Worker Backlog

| Priority | Worker lane | Owned write scope | First success criteria | Suggested gates |
| --- | --- | --- | --- | --- |
| 1 | PowerPoint reference generation | `tools/FreeP.RenderCompare/**`, checked-in refs or documented external artifact path | Deck refs 06-20 are generated on a PowerPoint COM machine and full-corpus compare can distinguish visual diff from missing baseline. | `tools/FreeP.RenderCompare --corpus-summary`; full render compare on COM-capable machine. |
| 2 | Remaining explicit Avalonia command gaps | `freep/FreeP.Ribbon.Definitions/**`, `freep/FreeP.App.Avalonia/**`, generated inventory docs/tests | Find, Replace, Layout, Hyperlink, and Remove Link move from `avalonia-gap` to shared or a justified non-gap classification. | Command inventory delta; `FreeP.Ribbon.Definitions.Tests`; focused `FreeP.App.Avalonia.Tests`; generated docs. |
| 3 | Design/Transitions/Animations shared planners | `FreeP.App.Presentation`, `FreeP.Ribbon.Definitions`, WPF/Avalonia host adapters/tests | Deferred WPF-only Design/Transitions/Animations controls gain shared timing/theme/transition planners before Avalonia exposure. | `RibbonTransitionsAnimationsTests`; new planner tests; command inventory delta. |
| 4 | Package semantic edit corpus | `freep/FreeP.Core.IO/**`, `freep/FreeP.App.Host.Tests/**`, corpus assertions | Corpus decks preserve parts/rels/content types after writer-owned edits, not only no-op retention. | Focused `PptxPackageRetentionTests`, `PptxRoundTripTests`, ZIP/OpenXML assertions. |
| 5 | Deep text and placeholder fidelity | `freep/FreeP.App.Presentation/**`, model/IO text defaults, WPF/Avalonia text render adapters/tests | Bullets, autofit, columns, vertical text, placeholders, tabs, effects, and default fonts route through shared plans. | `TextLayoutPlannerTests`; `BulletsAutofitTests`; `WordArtTests`; render-compare text decks. |
| 6 | Deep chart scene fidelity | `freep/FreeP.App.Presentation/**`, `freep/FreeP.Core.IO/**`, WPF/Avalonia rendering adapters/tests | Axis, label, data table, series-style, embedded workbook/cache, and type-specific chart decisions are shared. | `ChartRenderPlannerTests`; `ChartDataCommandTests`; `ChartTests`; selected render-compare decks. |
| 7 | Slide pane and table editing parity | `FreeP.App.Presentation`, `FreeP.App.Avalonia`, renderer adapters/tests | Avalonia gains WPF-equivalent slide pane interactions and table-cell editing through shared planners. | `SlidePane*` tests; new Avalonia table-cell tests. |
| 8 | Slideshow presenter model | `FreeP.App.Presentation`, WPF/Avalonia slideshow windows/tests | Presenter model, monitor selection planning, and timing/recording state are shared. | `SlideShowHostPlannerTests`; `SlideShowPlaybackPlannerTests`; WPF/Avalonia slideshow tests. |
| 9 | Export/print/backstage | `FreeP.App.Presentation`, `FreeP.Core.IO`, WPF/Avalonia host adapters/tests | PDF/export/print/backstage workflows become shared descriptors with thin host realization. | `PresentationPdfExporterTests`; new print/export/backstage tests; PDF/render inspection. |

## Validation Strategy

For report-only updates, run docs/preflight gates. For implementation workers, prefer focused tests plus a serialized build because this repo has had shared-output and WPF concurrency flakes.

Recommended gates by lane:

- Docs/report lane: `git diff --check`; `powershell -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1`.
- Shared planner/code lane: focused project tests plus `dotnet build FreeP.slnx --configuration Release -m:1 /nr:false`.
- Host/render lane: focused WPF/Avalonia tests plus render harness smoke.
- PowerPoint visual lane: run `tools/FreeP.RenderCompare` on a PowerPoint COM machine; do not claim authoritative parity from this machine.

Current integration stance: FreeP has a substantial shared codebase, generated command inventory, 20-deck package-retention contracts, trustworthy render-harness failure reporting, and initial shared chart/text/gesture planners. It is not PowerPoint-parity complete. The next work should close the remaining explicit Avalonia command gaps, generate missing PowerPoint refs on a COM-capable machine, and then continue deeper shared planner work for Design/Transitions/Animations, text, charts, export/print, presenter workflows, and review/accessibility surfaces.
