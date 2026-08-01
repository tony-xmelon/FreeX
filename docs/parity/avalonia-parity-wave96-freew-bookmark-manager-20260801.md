# Wave 96 FreeW Bookmark Manager

Date: 2026-08-01
Base: `f5beaa6b3d` (`codex/avalonia-parity-wave96-integration-20260801`)

## Scope

This slice aligns only the FreeW Bookmark Manager dialog family across WPF and
Avalonia. It covers the initial, populated, and generic validation-error route
states. Bookmark Manager has no editable validation input, so the validation
route remains non-destructive and uses the same document/list state as the
real dialog rather than inventing an error surface.

## Changes

- Matched the WPF 380 px dialog shell and 300 px list minimum.
- Matched the WPF 84 px action buttons, 6 px leading action margins, 6/3 px
  button padding, gray status text, and action order.
- Added mirrored dialog, heading, list, status, and action automation IDs.
- Made initial list focus deterministic on both hosts and kept actions disabled
  when the document has no bookmarks.
- Preserved the selected bookmark during Avalonia list refreshes and retained
  the WPF delete/status lifecycle.
- Added focused source/behavior guards and route adapters that seed a genuine
  two-bookmark populated document before either dialog is constructed.
- Scoped Avalonia disabled-button and focused-list brushes to the WPF authority
  palette without changing shared dialog chrome or unrelated routes.

## Visual Evidence

The canonical all-dialog generated report was not regenerated. Fresh route-only
artifacts are under:

`artifacts/freew-wave96-bookmark-manager-20260801/compare-fresh-r3/`

| State | Existing tracked baseline | Fresh changed ratio | Fresh mean channel delta | Result |
| --- | ---: | ---: | ---: | --- |
| `initial` | 3.1217% | 2.8863% | 1.6502 | pass |
| `populated` | 3.1217% | 2.7393% | 2.1545 | pass |
| `validation-error` | 3.1217% | 2.7393% | 2.1545 | pass |

All six host captures were valid (WPF 3/3, Avalonia 3/3); the three paired
rows have no semantic differences. The old canonical report remains at its
tracked 3.1217% value by design because this slice did not regenerate the
cross-dialog generated bundle.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~BookmarkManagerDialogParityTests" --logger "console;verbosity=minimal" --no-restore` — 3/3 passed.
- WPF, Avalonia, and comparison harness projects built in Release with 0 warnings and 0 errors.
- Route-only WPF capture: 3/3 captured.
- Route-only Avalonia capture: 3/3 captured.
- Route-only comparison: 3/3 pass, 0 semantic differences.
