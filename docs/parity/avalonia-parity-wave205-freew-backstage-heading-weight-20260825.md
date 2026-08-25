# Wave 205 — FreeW Backstage heading weight

## Scope

This slice aligns the shared Avalonia Backstage heading primitive with the WPF
authority used by FreeW. It covers the headings rendered by the common
Backstage pane composer, including Export, rather than adding an Export-only
override. Ink/Draw behavior and map-chart fidelity remain outside the active
parity scope.

## Change

`AvaloniaBackstageChrome.CreateHeading` now uses the same light heading weight
as WPF's `BackstagePaneComposer`. The separate pane-header primitive remains
semi-bold; it has a different role and was not part of the visual mismatch.

## Evidence

Fresh Export captures are retained under
`artifacts/wave205-freew-backstage-export`. Against the WPF authority, the
corrected Avalonia capture reduced changed pixels from 46,680 to 46,283 and
mean absolute channel delta from 10.9567 to 10.7064. Pane geometry, actions,
and the shell layout were already aligned.

## Verification

- `FreeW.DialogVisualHarness.Avalonia` Release build: passed.
- `BackstageViewTests`: 40 passed, 0 failed.
