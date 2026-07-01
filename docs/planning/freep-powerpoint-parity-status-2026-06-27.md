# FreeP PowerPoint Parity Status - Updated 2026-07-01

Status owner: FreeP parity orchestration. This report supersedes the 2026-06-27 pre-dedup FreeP snapshot. It is still a worker handoff and implementation plan, not a claim of full Microsoft PowerPoint parity.

Branch/worktree context for this update: `codex/freep-review-accessibility-planner-20260701`, based on `origin/main` commit `04e6c39f9`. This update reflects the 2026-07-01 FreeP parity implementation wave plus the shared Animations command planner slice and the shared comments/review/accessibility/alt-text workflow planning boundary.

## Current Evidence

- Primary repo root: `C:\Users\anton\OneDrive\Documents\FreeX\FreeX`.
- This report was refreshed from the current FreeP parity integration wave; local `main` may lag because integration is happening through isolated worktrees pushed to `origin/main`.
- `AGENTS.md` still requires isolated worktrees, no feature edits in `main`, frequent sync, subagents for independent work, and concrete validation before integration.
- `PowerPoint.Application` COM is not registered on this machine, so PowerPoint-authoritative visual baselines cannot be generated locally.
- The repo-wide parity scope at `docs/parity/2026-06-27-avalonia-wpf-parity-scope.md` has already been refreshed for the large dedup wave.

## 2026-07-01 Integration Checkpoint

The first post-dedup FreeP parity implementation wave is integrated on `main` through `04e6c39f9`, with this branch adding the shared comments/review/accessibility workflow planning boundary. It closed the initial evidence and shared-planning gates that were blocking reliable WPF/Avalonia parity work:

- Added a generated FreeP WPF/Avalonia command inventory at `docs/parity/freep-command-parity-inventory.md` and `.json`.
- Added 21-deck PPTX corpus retention contract tests for package-preservation evidence, including a deterministic FreeP-authored comments/notes fixture.
- Fixed `tools/FreeP.RenderCompare --avalonia-compare` trust reporting so PowerPoint export failure is not reported as success, and added corpus summary output.
- Moved chart legend planning, text render route planning, and canvas drag reduction into shared FreeP presentation-layer planners consumed by WPF and Avalonia.
- Expanded the Avalonia ribbon profile from the initial small surface to 86 shared command ids. The generated command inventory currently reports 94 total commands, 86 shared, 0 explicit Avalonia gaps, 0 known deferred commands, 6 platform-only commands, and 2 command-id aliases.
- Added shared presenter/slideshow state for current slide, next slide, notes text, start time, elapsed time, fullscreen intent, and monitor intent, with thin WPF and Avalonia slideshow-window adapters.
- Added a shared export planner for PDF/image/print descriptors, PDF dialog/picker plans, command IDs, and Backstage export plan; WPF and Avalonia now consume the same PDF export route with thin native file-picker/write adapters.
- Added shared export/print depth plans for image/video deferred exports, slide-range normalization, full-page slide printing, notes pages, and PowerPoint-style handout slide-count options.
- Added a shared transition command planner and exposed Transition commands through WPF and Avalonia thin adapters. WPF and Avalonia now route transition gallery, duration, advance-after, advance-on-click, and apply-to-all commands through the shared planner.
- Added a shared Design command planner and exposed theme plus slide-size commands through WPF and Avalonia thin adapters. Custom slide size is represented as a shared callback intent pending the full dialog.
- Added a shared Animations command planner and exposed effect, timing, ordering, and animation-pane commands through WPF and Avalonia thin adapters. Timing commands remain conservative when no selected value or selected-shape animation exists; the animation pane remains a host-local callback intent.
- Added a shared comments/review/accessibility/alt-text workflow planner that describes legacy comment pane actions, comment mutation intents, accessibility issue summaries, proofing scopes, and the current deferred persistent alt-text boundary.
- Added a shared table-cell edit planner for selected-cell normalization, edit start placement, commit/cancel routing, and enabled-state; WPF now consumes it and Avalonia has a tested adapter bridge for the next interactive overlay slice.
- Added semantic-edit package-retention coverage for high-risk corpus decks with media, charts, SmartArt diagrams, picture crop, chart types, chart labels, comments, and speaker notes.

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
| Shared presentation layer | `freep/FreeP.App.Presentation/**`. | App-neutral planners/controllers now cover persistence, file dialogs, slide composition, text layout, chart primitives, effects, picture color effects, gestures, hit testing, slide pane policy, slideshow host/playback, object insertion, dialogs, SmartArt layout, and comments/review/accessibility workflow planning. |
| Shared ribbon definitions | `freep/FreeP.Ribbon.Definitions/**`, `freep/FreeP.Ribbon.Definitions.Tests/**`, `docs/parity/freep-command-parity-inventory.*`. | WPF and Avalonia ribbon profiles are single-sourced with generated capability deltas. The current inventory reports 94 total commands, 86 shared, 0 explicit Avalonia gaps, and 0 known-deferred commands. |
| WPF app | `freep/FreeP.App.Host/**`, `freep/FreeP.App.Rendering.Wpf/**`, `freep/FreeP.App.Host.Tests/**`. | WPF is mostly a host/renderer adapter over shared policy, but still has richer dialog and editing coverage than Avalonia. Slide pane context actions and Design commands now route through shared planners. |
| Avalonia app | `freep/FreeP.App.Avalonia/**`, `freep/FreeP.App.Rendering.Avalonia/**`, `freep/FreeP.App.Avalonia.Tests/**`, `freep/FreeP.App.Rendering.Avalonia.Tests/**`. | Cross-platform shell and renderer exist. Avalonia consumes shared file workflow, ribbon definitions, slide pane planning/actions, rendering planners, shared presenter state, shared export planning, shared transition commands, shared Design commands, and shared Animations command planning. No explicit Avalonia command gaps or known-deferred command slices remain in the generated inventory. |
| PPTX lifecycle | `freep/FreeP.App.Presentation/PresentationFilePersistenceWorkflow.cs`, `freep/FreeP.App.Host/FileCommands.cs`, `shared/Free.Shared.Shell.Avalonia/SisterAvaloniaFileCommandWorkflow.cs`. | `.pptx` is now the default lifecycle path; `.fxp` remains legacy-compatible. The old WPF `.pptx` lifecycle gap is no longer a foundational blocker. |
| Package retention | `freep/FreeP.Core.Model/PptxPackageSnapshot.cs`, `PptxPackageReader.cs`, `PptxPackageWriter.cs`, `freep/FreeP.App.Host.Tests/PptxPackageRetentionTests.cs`. | Preservation machinery exists, the 21 tracked corpus decks have a retention contract test, and seven high-risk corpus decks now have semantic modeled-shape edit/save/reopen retention coverage. Comments and speaker notes now have explicit corpus package coverage; broader semantic edit breadth is still needed. |
| Render comparison | `tools/FreeP.RenderCompare/**`, `tools/FreeP.RenderCompare.Tests/**`, `tools/FreeP.RenderCompare/corpus/*.pptx`, `tools/FreeP.RenderCompare/PixelDiversity.cs`. | Harness supports WPF, Avalonia, PowerPoint, diff, pixel-diversity guards, explicit COM-unavailable reporting, and full-corpus summaries. Local PowerPoint COM is unavailable; the current local corpus summary is 21 decks total, 5 reference-ready, and 16 missing references. |

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
| FreeP WPF-vs-Avalonia command matrix | The generated matrix now exists and is the source of truth for command-surface work. Current state: 94 total, 86 shared, 0 explicit Avalonia gaps, 0 known deferred, 6 platform-only, 2 command-id aliases. | Keep `tools/Generate-FreePCommandParityInventory.ps1` and generated docs current as command slices land. | WPF/Avalonia only classify adapter-only or platform-only commands. | `tools/Test-GeneratedDocs.ps1`; `FreePRibbonDefinitionProfileTests.cs`. |
| Ribbon depth and stubs | The explicit Avalonia command gaps and known-deferred command slices are closed in the generated matrix. Transition, Design, and Animations command IDs are exposed through WPF/Avalonia planner-backed routes. Review/View/Accessibility/Recording, layout controls, and deeper workflow UI remain incomplete outside the current command matrix. | Shared ribbon definitions, command planners, layout/timing/animation models in `FreeP.App.Presentation`. | Host adapters render galleries, combo boxes, and dialogs. | Command inventory deltas; `RibbonEditorCompleteness5BTests.cs`; `RibbonTransitionsAnimationsTests.cs`; new stub-failure tests. |
| Render harness references | Pixel-diversity guards and trust reporting are in place. Only decks 01-05 have tracked PowerPoint PNG refs; decks 06-21 lack refs because local PowerPoint COM is unavailable. | `tools/FreeP.RenderCompare` reference freshness checks, corpus manifest, full-corpus summary. | WPF/Avalonia renderers only provide images. | Run refs on a PowerPoint COM machine; compare all 21 decks. |
| Package fidelity corpus contract | The 21 tracked decks now have a package-retention contract, and media/chart/SmartArt/comments/notes-focused decks have semantic modeled-shape edit coverage. Coverage is still thin for embedded workbooks, custom XML, and view/print settings. | `FreeP.Core.IO` package classification and writer merge rules; shared OPC helpers stay generic. | Hosts do not own package semantics. | Expand corpus open-save-reopen tests with targeted ZIP/OpenXML assertions after writer-owned edits. |
| Renderer orchestration duplication | Chart legend planning, text route planning, and drag reduction are now shared. Deeper chart/text/effects sequencing, axis/label realization, placeholder inheritance, and edit-state planning still need shared-core work. | Continue moving chart scene plans, text route decisions, and gesture/edit reducers into `FreeP.App.Presentation`. | Renderers map plans to WPF/Avalonia primitives. | `RendererNeutralDedupPlannerTests.cs`; `ChartRenderPlannerTests.cs`; `TextLayoutPlannerTests.cs`; `CanvasGesturePlannerTests.cs`; render tests. |
| Text and WordArt fidelity | PowerPoint parity requires better coverage for text metrics, bullets, autofit, columns, vertical text, placeholders, tabs, run effects, theme/default fonts, and WordArt. | `TextLayoutPlanner`, model/IO text defaults, placeholder inheritance, WordArt/warp planning. | Platform font measurement/drawing callbacks. | `BulletsAutofitTests.cs`; `WordArtTests.cs`; `TextColumnsGradOutlineTests.cs`; PowerPoint-backed deck refs. |
| Charts fidelity | Chart read/write and primitive planning exist, but PowerPoint chart layout, axes, labels, series styles, embedded workbook/caches, and type-specific visuals remain high risk. | `ChartShape`, `PptxChartReader/Writer`, `ChartRenderPlanner`, package retention. | Draw primitives only. | `ChartDataCommandTests.cs`; `ChartRenderPlannerTests.cs`; `ChartTests.cs`; `ChartDataLabelsTests.cs`; corpus decks 06, 18, 19. |
| SmartArt and modern object fidelity | SmartArt parsing/layout/fallback exists, but live SmartArt data/style/color parts and editing/rendering are not PowerPoint-complete. Modern/OLE/math objects still rely on fallback previews or placeholders. | Core model/IO package semantics, `SmartArtLayoutEngine`, modern object fallback policy. | Render previews/placeholders only. | `SmartArtTests.cs`; `SmartArtLayoutTests.cs`; `ModernObjectsRoundTripTests.cs`; `OleMathRoundTripTests.cs`; corpus deck 09/14. |
| Effects, media, connectors, and pictures | Effects/3D/crop/motion-path support is modeled, but visual parity needs PowerPoint-backed evidence and more shared planning where renderers still diverge. Avalonia slideshow sound is deferred/no-op. | Shared effects/media/connector/picture planners and PresentationML IO. | Platform media playback, image decoding, and drawing. | `PictureCropEffectsTests.cs`; `MotionPathTriggerTests.cs`; `Bevel3dTests.cs`; render corpus decks 07, 08, 10, 11, 12, 15, 16. |
| PDF/export/print/backstage | PowerPoint supports File > Export to PDF/video/handouts and print layouts for slides/handouts/notes. FreeP now has shared export descriptors, PDF dialog/picker plans, Backstage export plan, slide-range normalization, deferred image/video plans, and print layout plans for full-page slides, notes pages, and handouts. WPF/Avalonia PDF export routes consume the shared PDF path. PDF output includes basic slide background and shape rectangle draw ops, but full compositor/vector fidelity, actual image export, native print execution, video encoding, and handout rendering remain open. | Shared export/backstage/print planners; `PresentationPdfExporter` should continue moving toward compositor/draw-op-backed slide export. | Native print dialogs, owner windows, platform file pickers. | `PresentationPdfExporterTests.cs`; `PresentationExportPlannerTests.cs`; PDF/render inspection. |
| Slide pane and editing parity | Slide pane context actions, enabled-state, and drag-reorder action planning are now shared and consumed by WPF/Avalonia. Table-cell edit start/commit/cancel and selected-cell state now route through a shared planner consumed by WPF, with a tested Avalonia adapter bridge; the full Avalonia interactive overlay is still open. | `SlidePanePlanner`, `TableCellEditPlanner`, editing/session/table-cell planners, gesture reducer. | WPF/Avalonia list/control realization and input wiring. | `SlidePanePolicySourceGuardTests.cs`; `SlidePaneTests.cs`; `TableCellEditPlannerTests.cs`; `SlideCanvasAvaloniaTests.cs`. |
| Slideshow and presenter workflows | Shared presenter state now covers current slide, next slide, notes, elapsed time, fullscreen intent, and monitor intent, with thin WPF/Avalonia adapters. PowerPoint-grade Presenter View UI, rehearse/record timings, narration, laser/pen/highlighter, subtitles, and custom shows remain missing or shallow. | Shared slideshow/presenter/timing/recording/ink models and planners. | Fullscreen windows, monitor APIs, media element, cursor/input capture. | `SlideShowHostPlannerTests.cs`; `SlideShowPlaybackPlannerTests.cs`; `SlideShowTests.cs`; new presenter/recording tests. |
| Comments, accessibility, proofing, and alt text | PowerPoint includes modern comments, accessibility/alt text workflows, proofing, and review surfaces. FreeP now has a shared planner boundary for legacy comment pane actions, add/edit/delete intent payloads, accessibility issue summaries, alt-text request descriptors, and proofing scopes; it still lacks modern resolved-thread state, persistent alt-text model/IO, and full UI/workflow parity. | `PresentationReviewWorkflowPlanner`, comments/review/accessibility planners, model/IO for comments and alt text. | Pane/dialog realization and focus/UIA. | `PresentationReviewWorkflowPlannerTests.cs`; `SectionsCommentsTests.cs`; new modern comments/accessibility/alt-text UI tests. |

## Implementation Plan

Use small, isolated linked worktrees. Each worker should start from current `origin/main`, preserve unrelated work, and report exact validation. Do not put feature semantics directly in WPF or Avalonia host files when a shared planner/model can own them.

### Phase 0 - Evidence Gate First

Goal: make parity measurable before widening feature work. The first three evidence items are now complete on `main`; PowerPoint reference generation remains blocked on this machine by missing PowerPoint COM registration.

1. Done: fix `tools/FreeP.RenderCompare --avalonia-compare` so PowerPoint export failure returns failure.
2. Done: add machine prerequisite output that clearly separates "PowerPoint COM unavailable" from "FreeP parity failed".
3. Done: add a corpus manifest/full-corpus summary for the 21 tracked decks.
4. Generate missing PowerPoint reference PNGs for decks 06-21 on a machine with PowerPoint COM installed.
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
2. Done for explicit gaps and known-deferred command slices: expand Avalonia ribbon profile so Home clipboard/font/arrange/editing/slides, Insert shapes/tables/charts/links, Transitions, Design, and Animations are shared.
3. Continue replacing WPF stubs for layout and timing controls with shared planners before exposing the same commands in Avalonia.
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

1. Done for first presenter state: current/next slide, notes, timer, fullscreen intent, and monitor intent are shared; custom shows remain open.
2. Shared recording/timing/narration model and persistence.
3. Done for planning boundary: add shared comments/review/accessibility/alt-text workflow descriptors and focused tests. Modern comments, persistent alt text, host panes, and proofing/accessibility execution remain open.
4. Thin WPF/Avalonia panes/windows for presenter, comments, accessibility, and alt text.

### Phase 5 - Export, Print, And Backstage

Goal: graduate from text-only export to PowerPoint-shaped output workflows.

1. In progress: promote `PresentationPdfExporter` toward compositor/draw-op-backed slide export. Basic background and shape rectangle draw ops are now included.
2. Done for descriptors: add export descriptors for PDF, image, video, and print. Image/video implementations remain deferred explicitly.
3. Done for planning: add print layout planning for slides, notes pages, handouts, common slides-per-page options, and slide-range normalization.
4. Keep native print/file dialogs platform-specific.

## Worker Backlog

| Priority | Worker lane | Owned write scope | First success criteria | Suggested gates |
| --- | --- | --- | --- | --- |
| 1 | PowerPoint reference generation | `tools/FreeP.RenderCompare/**`, checked-in refs or documented external artifact path | Deck refs 06-21 are generated on a PowerPoint COM machine and full-corpus compare can distinguish visual diff from missing baseline. | `tools/FreeP.RenderCompare --corpus-summary`; full render compare on COM-capable machine. |
| 2 | Deep animation workflow fidelity | `FreeP.App.Presentation`, WPF/Avalonia host adapters/tests | Shared animation commands grow into richer pane/timeline editing, triggers, effect options, preview/playback, and persistence evidence. | `RibbonTransitionsAnimationsTests`; `PresentationAnimationCommandPlannerTests`; render/playback fixtures. |
| 3 | Package semantic edit corpus expansion | `freep/FreeP.Core.IO/**`, `freep/FreeP.App.Host.Tests/**`, corpus assertions | Additional corpus decks, especially custom XML/view-print settings, preserve parts/rels/content types after writer-owned edits. | Focused `PptxPackageRetentionTests`, `PptxRoundTripTests`, ZIP/OpenXML assertions. |
| 4 | Deep text and placeholder fidelity | `freep/FreeP.App.Presentation/**`, model/IO text defaults, WPF/Avalonia text render adapters/tests | Bullets, autofit, columns, vertical text, placeholders, tabs, effects, and default fonts route through shared plans. | `TextLayoutPlannerTests`; `BulletsAutofitTests`; `WordArtTests`; render-compare text decks. |
| 5 | Deep chart scene fidelity | `freep/FreeP.App.Presentation/**`, `freep/FreeP.Core.IO/**`, WPF/Avalonia rendering adapters/tests | Axis, label, data table, series-style, embedded workbook/cache, and type-specific chart decisions are shared. | `ChartRenderPlannerTests`; `ChartDataCommandTests`; `ChartTests`; selected render-compare decks. |
| 6 | Table editing parity | `FreeP.App.Presentation`, `FreeP.App.Avalonia`, renderer adapters/tests | Shared table-cell state/start/commit planning is in place for WPF and an Avalonia adapter bridge; next slice should add the full Avalonia interactive overlay and rich-text routing. | `TableCellEditPlannerTests`; `SlideCanvasAvaloniaTests`; WPF/Avalonia table-cell adapter tests. |
| 7 | Presenter recording and ink tools | `FreeP.App.Presentation`, WPF/Avalonia slideshow windows/tests | Existing shared presenter state grows into rehearse/record timings, narration intent, laser/pen/highlighter state, subtitles, and custom shows. | `SlideShowHostPlannerTests`; `SlideShowPlaybackPlannerTests`; WPF/Avalonia slideshow tests. |
| 8 | Export/print/backstage depth | `FreeP.App.Presentation`, `FreeP.Core.IO`, WPF/Avalonia host adapters/tests | Existing shared export descriptors and print plans grow into actual image export, native print execution/preview, handout rendering, video export, and stronger compositor-backed PDF fidelity. | `PresentationPdfExporterTests`; `PresentationExportPlannerTests`; PDF/render inspection. |
| 9 | Comments/accessibility UI realization | `FreeP.App.Presentation`, WPF/Avalonia host adapters/tests | The shared review workflow plans grow into thin comments pane, accessibility summary, alt-text dialog, and proofing host adapters without duplicating policy. | `PresentationReviewWorkflowPlannerTests`; focused WPF/Avalonia adapter tests. |

## Validation Strategy

For report-only updates, run docs/preflight gates. For implementation workers, prefer focused tests plus a serialized build because this repo has had shared-output and WPF concurrency flakes.

Recommended gates by lane:

- Docs/report lane: `git diff --check`; `powershell -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1`.
- Shared planner/code lane: focused project tests plus `dotnet build FreeP.slnx --configuration Release -m:1 /nr:false`.
- Host/render lane: focused WPF/Avalonia tests plus render harness smoke.
- PowerPoint visual lane: run `tools/FreeP.RenderCompare` on a PowerPoint COM machine; do not claim authoritative parity from this machine.

Current integration stance: FreeP has a substantial shared codebase, generated command inventory with zero explicit Avalonia command gaps and zero known-deferred command slices, 21-deck package-retention contracts plus first semantic-edit corpus coverage for media, charts, SmartArt, comments, and notes, trustworthy render-harness failure reporting, initial shared chart/text/gesture planners, shared slide-pane action planning, shared table-cell edit state/start/commit planning, shared presenter/slideshow state consumed by WPF and Avalonia, shared export/backstage planning with WPF/Avalonia PDF export routes, shared export/print depth descriptors for image/video/slide/notes/handout workflows, shared transition, Design, and Animations command intents exposed through WPF/Avalonia, and a shared comments/review/accessibility workflow planning boundary. It is not PowerPoint-parity complete. The next work should generate missing PowerPoint refs on a COM-capable machine, then continue deeper shared planner work for animation workflow fidelity, text, charts, actual export/print execution, presenter recording/ink tools, the full Avalonia table-cell editing overlay, modern comments/review UI, persistent alt-text model/IO, and accessibility surfaces.
