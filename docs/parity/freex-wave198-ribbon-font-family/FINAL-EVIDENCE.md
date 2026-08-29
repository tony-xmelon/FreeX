# Wave198 Final Physical Evidence

Accepted run: `20260829T040529Z`

The original runner output was generated under the ignored
`artifacts/linux-interactive/freex/interaction-validation/20260829T040529Z/`
directory. Its durable promoted report, manifest, postcondition, provenance,
package proof, screenshots, and checksums are tracked under
`docs/parity/freex-wave198-ribbon-font-family/evidence/`.

## Provenance

- Source commit: `11bff13a7c79d3d63b8aae4aa04e3652f4411667`
- Payload fingerprint: `8e98855334aa681317ea5658a60ad7049315a8d076d03a15bb834de143a9c315`
- Payload file count: `778`
- App image: `freex-linux-interactive-app-freex-29fc9341a543:current`
- App image ID: `sha256:82cedc8a29edda2963cba8c948e5cd7f65e5390553320761c015dbd2a7aa65d3`
- Validation mode: physical-only Linux X11 Avalonia
- Row result: `ribbon-home-font-family-combo-physical=passed`, `1/1`

## Postcondition

- Fixture: `/documents/freex-wave198-ribbon-font-family.xlsx`
- Target: `A1`
- Ribbon path: `Alt,H`, rendered Home Font combo, dropdown arrow `323,96`, Arial item `280,149`
- Selected font: `Arial`
- Automatic combo-close focus: `not-measured`; status: `unresolved-not-measured`
- Explicit worksheet reselect: `29,236`
- Subsequent keyboard check: `Right`, `Ctrl+C`, clipboard `Unchanged` from `B1`
- Save: `save-clean=true`
- XLSX package: `style-id=1|font-id=1|font-name=Arial|font-family=true`

The original report directory under ignored `artifacts/` is non-retained and may
disappear with this worktree. The compact durable bundle under `evidence/`
contains the promoted report facts, provenance, manifest, package proof, and
relevant screenshots. `evidence/SHA256SUMS.txt` hashes every promoted file.
Earlier failed or superseded run directories were discarded.

## Focused Tests

Command:

`dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~Wave198RibbonFontFamilyPhysicalSourceTests|FullyQualifiedName~Wave197RibbonNumberFormatPhysicalSourceTests" --logger "console;verbosity=minimal"`

Result: `5 passed, 0 failed, 0 skipped`.

## Boundaries

This proves one selected cell, one catalogued family (`Arial`), one Linux
X11/Avalonia production path, clean save, and package persistence. It does not
prove automatic focus restoration, broad font coverage, arbitrary font-name
entry, WPF execution, Wayland behavior, or broad parity.

The rejected Wave198 focus candidates leave zero net focus-specific diff in
`src/FreeX.App.Avalonia/MainWindow.cs` versus the Wave198 worker base
`f5f549461da4518195596dd63ccbeef2d36c4d8c`. The integration branch also
contains unrelated upstream Round167 changes in that file; this statement does
not characterize the whole integration-file diff.

## Rejected Candidates

- `20260829T030825Z`: rejected; the initial `280,96` click missed the rendered dropdown, so Arial was not selected.
- `20260829T031314Z`, `20260829T031826Z`, `20260829T032442Z`, `20260829T032941Z`, and `20260829T033634Z`: rejected focus-fix candidates; Arial/package/save passed, but automatic combo-close focus remained false.
- `20260829T034117Z`: rejected for the same unproven automatic-focus result.
- `20260829T035313Z`: rejected for final-source provenance/sequence; its source SHA was correct but the explicit worksheet reselect keyboard check was false.
- `20260829T035213Z`: no report; publish failed before the app container started.
