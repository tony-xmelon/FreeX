# Wave196 Cross-App Integration

Wave 196 records three bounded Avalonia parity slices: one FreeX ribbon-formatting
slice, one FreeW trailing-flow-break caret slice, and one FreeP deck17 rendering
slice. Cumulative accounting is **588 app slices** (**196 per app**). The overall
Avalonia/WPF 100% parity goal remains incomplete.

## FreeX

The committed FreeX evidence is
`docs/parity/freex-wave196-ribbon-formatting/README.md` plus
`tests/FreeX.App.Avalonia.Tests/Wave196RibbonFormattingPhysicalSourceTests.cs`.
It records one production Docker/X11 ribbon-formatting probe, 22/22 focused
source tests, and exact saved-package evidence of
`style-id=1|font-id=1|bold=true` with `save-clean=true`. This is bounded evidence
for the Home ribbon Bold key-tip route, not exhaustive FreeX or visual parity.

## FreeW

The committed FreeW evidence is
`freew/docs/parity/avalonia-parity-wave196-freew-paged-caret-boundary-20260829.md`
plus the regression coverage in
`freew/FreeW.App.Avalonia.Tests/DocumentViewHeadlessTests.cs`. Two focused source
regressions cover the single trailing page/column break and consecutive trailing
break boundaries (2/2 focused cases), including non-zero caret geometry at the
final post-break location. This is a focused editor-boundary slice, not complete
FreeW or visual parity.

## FreeP

The committed FreeP evidence is the deck17 light-hinting note and its metrics and
image-hash bundle under
`docs/parity/evidence/freep-wave196-deck17-light-hinting-20260829/`, with source
coverage in the two Wave196 FreeP tests. For the fixed-size single-column,
no-autofit, non-bullet 18pt Aptos body fallback, the recorded Avalonia/Office
measurement changes from 2.5360% to 2.4820%, and WPF/Avalonia changes from
2.9091% to 2.8755%; the slide01 control remains unchanged. This is a scoped
renderer measurement, not complete PowerPoint or visual parity.

## Integration Status

Wave196 local integration gates are **pending**. The repository preflight and full
Release build are the local branch gates required by `AGENTS.md`; both remain
pending in this dashboard. The delegated manifest-driven integration and
UI/render/release-only workflows are not claimed as locally run. No Wave196
tested-source or acceptance SHA is recorded, and this note does not claim full
parity.

The cross-platform portability correction is included in the dashboard generator
and its focused host test: repository paths use forward slashes so the generated
dashboard is stable across PowerShell hosts.

Wave195 remains historical data in the generated dashboard, including its accepted
local gates, exact tested source boundary, app evidence, and nested Wave194
acceptance history.
