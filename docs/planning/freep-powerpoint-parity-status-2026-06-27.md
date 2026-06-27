# FreeP PowerPoint Parity Status - 2026-06-27

Status owner: FreeP parity orchestration. This note is a current worker handoff, not a replacement for the original Wave 1 foundation design in `docs/planning/freep-foundation/DESIGN.md`.

Branch/worktree context for this note: `codex/freep-parity-doc-status-20260627` at `origin/main` commit `a2153c1060549fa05d2aec3835082144eae35554`. The implementation evidence below is grounded in repo paths present on that commit plus the green focused gates reported by the FreeP scoping worktree `FreeX/.worktrees/freep-parity-scope-20260627`.

## Current Implementation Reality

FreeP is no longer a stub shell. The repo contains the following concrete implementation surfaces:

| Area | Current repo evidence | Status |
| --- | --- | --- |
| Solution map | `FreeP.slnx` includes shared app services, shared drawing/ribbon/shell projects, FreeP model/IO/presentation/rendering/host projects, Avalonia app/tests, and `tools/FreeP.RenderCompare`. | Dedicated FreeP solution exists. |
| WPF app | `freep/FreeP.App.Host/`, `freep/FreeP.App.Rendering.Wpf/`, and `freep/FreeP.App.Host.Tests/`. | WPF shell and renderer exist and have broad host coverage. |
| Avalonia app | `freep/FreeP.App.Avalonia/`, `freep/FreeP.App.Rendering.Avalonia/`, `freep/FreeP.App.Avalonia.Tests/`, and `freep/FreeP.App.Rendering.Avalonia.Tests/`. | Cross-platform shell/rendering path exists, with a narrower command surface than WPF. |
| PPTX IO | `freep/FreeP.Core.IO/PptxPackageReader.cs`, `PptxPackageWriter.cs`, `PptxChartReader.cs`, `PptxChartWriter.cs`, `PptxColorReader.cs`, and `PresentationPdfExporter.cs`. | PPTX reader/writer exists, including charts and PDF export plumbing. |
| Presentation model | `freep/FreeP.Core.Model/Presentation.cs`, `Slide.cs`, `TextBody.cs`, `ChartShape.cs`, `SmartArtShape.cs`, `PreservedObjectInfo.cs`, command files, comments, animation, transition, OLE, and math model files. | Broad PowerPoint-domain model exists. |
| Presentation compositor | `freep/FreeP.App.Presentation/SlideCompositor.cs`, `DrawOps.cs`, `EditingSession.cs`, `SmartArtLayoutEngine.cs`, `ThemeColorResolver.cs`, geometry/effects helpers, and command tests. | App-neutral presentation layer exists. |
| Render comparison | `tools/FreeP.RenderCompare/Program.cs`, `PowerPointInterop.cs`, `FreePRenderer.cs`, `FreePAvaloniaRenderer.cs`, `ImageDiff.cs`, and `tools/FreeP.RenderCompare/corpus/*.pptx`. | Harness and 20-deck corpus exist, but trust gaps remain before it should be treated as authoritative. |

Focused gates from orchestration are green in the FreeP scoping worktree:

| Gate | Result |
| --- | --- |
| `freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj` | 493/493 passed |
| `freep/FreeP.App.Host.Tests/FreeP.App.Host.Tests.csproj` | 859/859 passed |
| `freep/FreeP.App.Rendering.Avalonia.Tests/FreeP.App.Rendering.Avalonia.Tests.csproj` | 59/59 passed |

## Remaining PowerPoint Parity Gaps

These are the gaps called out by the scouts and still visible from the current file map:

| Gap | Why it matters | Primary paths |
| --- | --- | --- |
| Package retention | FreeP has `PreservedObjectInfo` and recent preserved-object work, but byte/part retention is not yet a broad package-fidelity contract. Unmodeled parts, relationships, content types, and namespace choices still need systematic retention tests against real decks. | `freep/FreeP.Core.Model/PreservedObjectInfo.cs`; `freep/FreeP.Core.IO/PptxPackageReader.cs`; `freep/FreeP.Core.IO/PptxPackageWriter.cs`; `freep/FreeP.App.Host.Tests/ModernObjectsRoundTripTests.cs` |
| WPF `.pptx` lifecycle mismatch | The WPF shell has real file commands, but lifecycle parity still needs a PowerPoint-shaped open/save/save-as/dirty/recent/close behavior audit, especially where legacy `.fxp` behavior and `.pptx` behavior can diverge. | `freep/FreeP.App.Host/FileCommands.cs`; `freep/FreeP.App.Host/MainWindow.cs`; `freep/FreeP.App.Host.Tests/FileLifecycleTests.cs`; `freep/FreeP.Core.IO/FxpFormat.cs` |
| Render harness trust | `tools/FreeP.RenderCompare` can export from PowerPoint and render FreeP outputs, but the WPF offscreen path has produced blank-output concerns and the harness lacks enough self-checks to make a green diff automatically trustworthy. | `tools/FreeP.RenderCompare/FreePRenderer.cs`; `tools/FreeP.RenderCompare/FreePAvaloniaRenderer.cs`; `tools/FreeP.RenderCompare/PowerPointInterop.cs`; `tools/FreeP.RenderCompare/ImageDiff.cs` |
| Missing local PowerPoint COM baseline | The harness depends on a local Microsoft PowerPoint COM install for authoritative export. Current local availability is not documented as a validated baseline for this lane, so parity claims should distinguish unit-test coverage from PowerPoint-backed evidence. | `tools/FreeP.RenderCompare/PowerPointInterop.cs`; `tools/FreeP.RenderCompare/corpus/` |
| Text fidelity | Rich text exists, but PowerPoint parity needs deeper coverage for bullets, autofit, columns, vertical text, theme/default font fallback, run metrics, placeholders, and WordArt text behavior. | `freep/FreeP.Core.Model/TextBody.cs`; `freep/FreeP.App.Rendering.Wpf/TextBodyFlowDocumentConverter.cs`; `freep/FreeP.App.Presentation.Tests/BulletsAutofitTests.cs`; `WordArtTests.cs`; `TextColumnsGradOutlineTests.cs` |
| Effects fidelity | Shape fills, gradients, outlines, 3D bevels, picture crop, motion paths, and custom geometry are modeled/tested, but visual parity against PowerPoint is still partial until render-compare evidence is reliable. | `freep/FreeP.Core.Model/ShapeFill.cs`; `ShapeOutline.cs`; `ShapeAnimation.cs`; `freep/FreeP.App.Presentation/CustomGeometryBuilder.cs`; `BevelGeometryHelper.cs`; `freep/FreeP.App.Host.Tests/PictureCropEffectsTests.cs`; `MotionPathTriggerTests.cs` |
| Charts fidelity | Chart reader/writer and commands exist, but PowerPoint chart layout, labels, axis details, embedded workbook behavior, and chart-type visual parity remain a separate high-risk lane. | `freep/FreeP.Core.Model/ChartShape.cs`; `freep/FreeP.Core.IO/PptxChartReader.cs`; `PptxChartWriter.cs`; `freep/FreeP.App.Presentation.Tests/ChartDataCommandTests.cs`; `freep/FreeP.App.Host.Tests/ChartTests.cs`; `ChartDataLabelsTests.cs` |
| SmartArt fidelity | FreeP has model/layout tests and fixtures, but real SmartArt preservation/editing/rendering fidelity is still not PowerPoint-complete. | `freep/FreeP.Core.Model/SmartArtShape.cs`; `freep/FreeP.App.Presentation/SmartArtLayoutEngine.cs`; `freep/FreeP.App.Presentation.Tests/SmartArtLayoutTests.cs`; `tools/FreeP.RenderCompare/SmartArtFixtureGenerator.cs`; `tools/FreeP.RenderCompare/corpus/14-smartart-live.pptx` |
| PDF export is text-only/limited | `PresentationPdfExporter` exists, but the current parity concern is that export is not yet a faithful PowerPoint slide export across drawings, images, effects, charts, SmartArt, and animations/transitions where applicable. | `freep/FreeP.Core.IO/PresentationPdfExporter.cs`; `freep/FreeP.App.Host.Tests/PresentationPdfExporterTests.cs` |
| Avalonia command surface | Avalonia app/rendering exists, but command coverage is behind WPF and needs explicit parity mapping for ribbon actions, file lifecycle, editing gestures, dialogs, slideshow, and backstage. | `freep/FreeP.App.Avalonia/MainWindow.cs`; `FreePRibbonAvalonia.cs`; `freep/FreeP.App.Avalonia.Tests/MainWindowHeadlessTests.cs`; `freep/FreeP.App.Rendering.Avalonia.Tests/SlideCanvasAvaloniaTests.cs` |
| WPF ribbon stubs | WPF host has a ribbon, command catalog, and icons, but some PowerPoint ribbon commands remain placeholders or shallow routes rather than complete PowerPoint-equivalent workflows. | `freep/FreeP.App.Host/FreePRibbon.cs`; `FreePRibbonCommands.cs`; `FreePRibbonIcons.cs`; `freep/FreeP.App.Host.Tests/RibbonEditorCompleteness5BTests.cs`; `RibbonTransitionsAnimationsTests.cs` |
| Modern comments, presenter view, and backstage gaps | Comments, slideshow, and backstage surfaces exist, but modern comment workflows, presenter view parity, export/account/backstage details, and Office-style sharing/review affordances remain incomplete. | `freep/FreeP.Core.Model/SlideComment.cs`; `freep/FreeP.App.Host/Backstage/BackstageView.cs`; `freep/FreeP.App.Host/SlideShowWindow.cs`; `freep/FreeP.App.Avalonia/SlideShowWindow.cs`; `freep/FreeP.App.Host.Tests/SectionsCommentsTests.cs`; `SlideShowTests.cs` |

## First-Wave Worker Backlog

Run these as isolated linked worktrees with non-overlapping write scopes. Each worker should start from `origin/main`, preserve unrelated sessions, and report exact test/harness evidence.

| Priority | Worker lane | Suggested owner scope | First success criteria | Gates |
| --- | --- | --- | --- | --- |
| 1 | Package-retention contract | Core.IO/Core.Model worker | Add/confirm preserved-part inventory for real decks; prove unmodeled package parts, relationships, content types, media, charts, SmartArt, OLE/math, comments, and extension lists survive open-save-reopen without loss outside intentionally modeled edits. | Focused `FreeP.App.Host.Tests` round-trip tests; targeted package ZIP/OpenXML assertions; `git diff --check`. |
| 2 | WPF `.pptx` lifecycle parity | WPF host worker | Align PowerPoint-like New/Open/Save/Save As/Close/dirty/recent behavior around `.pptx`; keep `.fxp` legacy support explicit and non-primary. | `freep/FreeP.App.Host.Tests/FileLifecycleTests.cs`; file-command source tests; focused WPF host tests. |
| 3 | Render harness trust | Tools/render worker | Add nonblank/canvas-size/self-diff guards, fail-fast diagnostics, and documented prerequisites for PowerPoint COM availability; separate "PowerPoint unavailable" from "FreeP parity failed". | `tools/FreeP.RenderCompare --diff`; corpus smoke deck compare when COM is available; unit/source tests if added. |
| 4 | WPF offscreen blank fix | WPF rendering worker | Make `FreePRenderer` produce deterministic nonblank slide PNGs for the corpus without relying on visible app windows. | `tools/FreeP.RenderCompare --freep-render tools/FreeP.RenderCompare/corpus/01-title-slide.pptx <out>` plus image nonblank check; focused WPF rendering tests where practical. |
| 5 | Text/effects visual wave | Presentation + rendering worker | Pick a small corpus slice (`03-mixed-text`, `08-effects`, `13-wordart`, `17-bullets-autofit`, `20-columns-gradoutline`) and drive one measurable PowerPoint-vs-FreeP reduction. | Relevant `FreeP.App.Presentation.Tests`; host/rendering tests; render-compare evidence if trusted enough. |
| 6 | Chart/SmartArt fidelity wave | Core.IO + compositor worker | Split chart and SmartArt into separate lanes if both are active; expand reader/writer/compositor evidence for one corpus deck at a time. | `Chart*Tests` or `SmartArt*Tests`; package assertions; render-compare evidence when available. |
| 7 | PDF export parity triage | Core.IO/export worker | Document and test current export capability, then promote from text-only/limited output toward real slide drawing export for one deck class. | `PresentationPdfExporterTests`; PDF text/image/render inspection if available. |
| 8 | Avalonia command-surface map | Avalonia worker | Produce a WPF-vs-Avalonia command map, then implement the first missing high-value route without touching WPF-owned files. | `freep/FreeP.App.Avalonia.Tests`; `freep/FreeP.App.Rendering.Avalonia.Tests`; source-hygiene test if added. |
| 9 | WPF ribbon completeness | WPF ribbon worker | Convert the next set of ribbon stubs into tested command routes and keep command names/icons aligned. | `RibbonEditorCompleteness5BTests`; `RibbonTransitionsAnimationsTests`; focused host tests. |
| 10 | Modern shell gaps | Host/Avalonia shell worker | Split modern comments, presenter view, and backstage into separate follow-up lanes after lifecycle/render-harness blockers are under control. | Focused host/Avalonia tests per feature; no broad default-lane claim until implemented. |

## Orchestration Map

Recommended sequencing:

1. Package retention and lifecycle parity first. They define whether FreeP can safely round-trip real user decks.
2. Render harness trust next. Without a reliable harness, visual work cannot graduate from unit coverage to PowerPoint parity evidence.
3. Text/effects/charts/SmartArt visual waves after the harness can prove nonblank, matched-size, PowerPoint-backed comparisons.
4. Avalonia command surface and WPF ribbon completeness in parallel, but with explicit file ownership: Avalonia workers own `freep/FreeP.App.Avalonia/**` and `freep/FreeP.App.Rendering.Avalonia/**`; WPF ribbon workers own `freep/FreeP.App.Host/FreePRibbon*` and host tests.
5. Modern comments, presenter view, backstage, and PDF export should each become narrow lanes with their own evidence rather than one umbrella parity branch.

Current integration stance: ready for worker dispatch, not ready to claim full PowerPoint parity. The implementation base is substantial and the focused unit gates are green, but PowerPoint-authoritative visual/package evidence and several user-facing workflow surfaces remain incomplete.
