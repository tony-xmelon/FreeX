# Wave199 Final Physical Evidence

## Result

Run: `20260829T062304Z`

This is a truthful rejected-candidate bundle. The physical Linux X11/Avalonia row failed, so the candidate was not retained in production source.

## Provenance

- Base source commit recorded by the runner: `4760be18736bf14affc66746b450ad093e54a6bf`
- Payload fingerprint: `542ea61e758181fb0f34c9b76650772fd711a944e399e205f1e16b572a6c4951`
- Payload file count: `778`
- App image: `freex-linux-interactive-app-freex-fb590e6aff7f:current`
- App image ID: `sha256:d8e38b96ab9a161a3c04c882cbaa931cc286db2e343ccb9a594b7c878022eb85`
- Validation mode: physical-only Linux X11 Avalonia
- Row result: `ribbon-home-font-family-combo-physical=failed`, `0/1`

The image included the one Wave199 production focus candidate. That candidate was reverted after this run; the current branch contains only the probe, tests, and this evidence.

## Measured Postcondition

- Fixture: `/documents/freex-wave198-ribbon-font-family.xlsx`
- Target: `A1`
- Ribbon path: `Alt,H`, rendered Home Font combo, dropdown arrow `323,96`, Arial item `280,149`
- Selected font shown by the combo: `Arial`
- Automatic combo-close focus: `false`; status: `failed`
- Automatic clipboard probe: `Wave198 Font Family Target` (the original `A1` value, not the expected `B1` value)
- Explicit worksheet reselect: `29,236`; result: `true`
- Explicit keyboard check: `Right`, `Ctrl+C`, clipboard `Unchanged`
- Save: `save-clean=false`
- XLSX package: `style-id=0|font-id=0|font-name=Calibri|font-family=false`

The automatic probe runs before `select_cell 0 0 A1`; its order is asserted by `Wave199RibbonFontFamilyFocusSourceTests`. No result is hard-coded.

`SHA256SUMS.txt` records canonical Git/blob-byte hashes. Text evidence is normalized to the repository `eol=lf` policy before hashing; PNG evidence is hashed byte-for-byte.

## Focused Tests

Command:

`dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~Wave199RibbonFontFamilyFocusSourceTests|FullyQualifiedName~Wave198RibbonFontFamilyPhysicalSourceTests|FullyQualifiedName~RibbonComboPopupClose_RestoresWorksheetFocusForWorkbookShortcuts" --logger "console;verbosity=minimal"`

Result before final evidence packaging: `6 passed, 0 failed, 0 skipped`.

## Rejected Candidate And Remaining Gap

The rejected candidate captured `combo.IsKeyboardFocusWithin || combo.IsFocused` synchronously at `DropDownClosed` and deferred the existing focus policy. It was rejected because the physical run still failed automatic focus and font persistence/save-clean. A selection-driven handoff was considered during analysis but was not run or retained, in accordance with the single-candidate limit for this slice.

Remaining gap: identify the actual Avalonia popup/focus event route that differs from WPF, then validate a new production change with both automatic worksheet focus and clean Arial package persistence passing in one physical run.
