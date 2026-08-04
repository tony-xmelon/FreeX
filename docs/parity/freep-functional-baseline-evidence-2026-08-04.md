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

The validator now accepts `--decks <name[,name...]>`, isolates each deck's
PowerPoint COM export, and reports each completed deck before printing the
aggregate. The complete current-main run completed all `27/27` decks and
`53/53` reference slides with `0` failed exports, `0` missing references, and
`0` reference diffs. This supersedes the earlier targeted-only result; owned
child processes and temporary output were cleaned up, and unrelated PowerPoint
processes were left untouched.

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

The validator's per-deck isolation is now closed. Remaining function-first work
is to deepen real presenter capture, permissions/error paths, advanced animation
authoring, richer SmartArt and chart editing, foreground/driver-level native
printer validation, portable non-Windows OLE, and real-deck media/recording
coverage. WPF native print handoff and the Avalonia platform printer route are
present; the remaining printer item is OS-owned behavior and evidence, not a
missing application command path. Visual work remains secondary unless it proves
one of those functions is being consumed.
