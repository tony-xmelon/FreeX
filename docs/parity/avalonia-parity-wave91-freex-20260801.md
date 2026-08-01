# FreeX Wave 91 Functional Parity

Date: 2026-08-01
Branch: `codex/agent-freex-functional-wave91-20260801`
Baseline: `origin/main` at `0ffec009b42f328f68cf3fe5251c591d1c4e32bf`

## Selected gap

Wave 90's generated FreeX dashboard reported command and dialog coverage, but it did not prove
that the copy/paste workflow preserved the selected object target. The WPF host already had an
R91 authority test and an internal object clipboard. Avalonia's keyboard, ribbon, native-menu, and
worksheet-context-menu routes all went directly to range-text clipboard methods. With a chart,
shape, picture, or text box selected, Ctrl+C therefore copied the cell under the object's anchor
instead of the object itself.

This was selected as the highest-severity remaining FreeX asymmetry because it changes user data
and is reachable through the primary editing workflow. It is a real host behavior gap, not a
generated-evidence shortfall or a feature missing from both hosts.

## Implementation

- Added an Avalonia internal object clipboard carrying source sheet, object kind, and object id.
- Routed the existing Avalonia copy/paste choke points, so keyboard, ribbon, native menu, and
  worksheet context-menu commands share the behavior.
- Copying a selected chart, shape, picture, or text box now uses `DuplicateDrawingObjectCommand`
  on paste, including same-sheet and cross-sheet destination support supplied by the command.
- The pasted object is reselected and the contextual ribbon state is restored.
- Ordinary cell copy remains on the existing range-text path.
- Escape clears an object copy, and a later Cut/Copy invalidates stale object-copy state.
- Added a headless Avalonia theory covering all four object kinds. The existing WPF R91 authority
  test remains unchanged and was rerun as the paired regression.

## Verification

Focused foreground commands run from this worktree:

```text
dotnet build src\FreeX.App.Avalonia\FreeX.App.Avalonia.csproj --configuration Release --no-restore
dotnet test tests\FreeX.App.Avalonia.Tests\FreeX.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~R91_AvaloniaObjectClipboardCopyPasteTests"
dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~R91_ObjectClipboardCopyPasteTests"
```

Results: Avalonia `4 passed`; WPF authority `2 passed`; app build `0 warnings, 0 errors`.

Docker validation was not run because it is orchestrator-owned and sequential. No machine-wide
processes or build servers were stopped.

## Residuals

Object Cut still follows the existing range-cut path; moving an object with Ctrl+X/Ctrl+V remains a
separate behavior slice. The object clipboard is an in-process FreeX clipboard, matching the WPF
authority, while external applications still receive the existing cell clipboard formats. Physical
desktop and Docker validation were not part of this focused slice.
