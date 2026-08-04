# FreeP Functional Baseline Evidence - 2026-08-04

This is a function and evidence-harness record, not a claim of complete Microsoft
PowerPoint parity.

## PowerPoint Corpus

- PowerPoint COM is registered on the comparison host.
- The corpus contains 27 decks and 53 slides.
- The complete reference inventory is now `27/27` decks and `53/53` slide PNGs.
- `15-smartart-grouped-list.pptx` was missing references at the start of this
  run; a fresh PowerPoint COM export produced all 10 slides successfully.
- The authoritative command used for the missing deck was:
  `dotnet run --project tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --configuration Release --no-restore -- --powerpoint-export tools/FreeP.RenderCompare/corpus/15-smartart-grouped-list.pptx tools/FreeP.RenderCompare/corpus/pptx-ref/15-smartart-grouped-list --width 1280 --height 720`

The validator now accepts `--decks <name[,name...]>` and reports each completed
deck before printing the aggregate. A targeted retry of the historically
problematic decks completed successfully:

- `10-motionpath.pptx`: exported `1/1`, reference match `1/1`.
- `14-smartart-live.pptx`: exported `4/4`, reference match `4/4`.
- `21-comments-notes.pptx`: exported `2/2`, reference match `2/2`.

The targeted run therefore completed `3/3` decks and `7/7` reference matches
with no missing or differing slides. The earlier unfiltered multi-deck run did
not return within its bounded session window; use the filter for focused triage
and retain the per-deck timeout for broad runs. Owned child processes and
temporary output were cleaned up; the existing PowerPoint process was left
untouched.

## Windows Video Functionality

The native Windows MediaComposition path is executable on this host:

- WPF `WpfVideoExportAdapter` tests: `7/7`.
- Avalonia `WindowsNativeVideoAdapter` export test: `1/1`.
- Shared Windows recording backend tests: `11/11`.
- The native export test produced a non-empty MP4 and validated the output
  package path. Narration/camera device permission and availability remain
  environment-dependent and are separately reported by the recording planner.

Commands:

- `dotnet test freep/FreeP.App.Host.Tests/FreeP.App.Host.Tests.csproj --configuration Release --filter FullyQualifiedName~WpfVideoExportAdapter`
- `dotnet test freep/FreeP.App.Avalonia.Tests/FreeP.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~WindowsNativeVideoAdapter`
- `dotnet test freep/FreeP.App.Recording.Tests/FreeP.App.Recording.Tests.csproj --configuration Release --filter FullyQualifiedName~WindowsRecordingCaptureBackendTests`

## Remaining Function Gaps

The next function-first work should address the bounded validator's per-deck
process isolation and then deepen real presenter capture, permissions/error
paths, custom-show persistence, advanced animation authoring, richer SmartArt
and chart editing, native printer handoff, and OLE hosting. Visual work remains
secondary unless it proves one of those functions is being consumed.
