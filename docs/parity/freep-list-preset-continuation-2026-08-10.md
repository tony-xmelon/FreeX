# FreeP list preset continuation

Applying a numbered list preset to several selected paragraphs now treats the
preset start value as a single sequence restart. Only the first selected
paragraph retains the explicit `AutoNumStartAt` and restart-presence flag;
following paragraphs use ordinary continuation metadata. This prevents a
non-default preset start such as 4 from repeating `4.` on every selected item.

The change is shared by the WPF and Avalonia table-cell rich-text routes. The
regression contract checks the model flags and the shared marker state produces
`4, 5, 6` for three selected paragraphs.

Verification:

- focused presentation test: 1/1
- list-preset planner tests: 4/4
- `TableCellEditPlannerTests`: 56/56
- focused WPF editor host tests: 2/2
- `FreeP.App.Host` Release build: 0 warnings, 0 errors
