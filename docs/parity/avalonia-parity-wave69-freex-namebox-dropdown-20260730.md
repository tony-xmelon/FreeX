# FreeX Wave 69: Open Name Box Dropdown Pair

Date: 2026-07-30
Scope: FreeX WPF/Avalonia parity capture and comparison tooling only.

## Contract

The open Name Box dropdown is now a paired surface with the stable id `popup.nameBoxDropdown` and kind `overlay`.
Both shells render a fixed `208x136` pixel frame at 96 DPI. The pair contract fails closed when either side is missing,
uncaptured, misclassified, mis-sized, absent on disk, undecodable, or uniformly white/transparent.

The WPF capture opens the production `CellAddressBox` ComboBox after calling the existing screenshot-tour fixture
authority. The fixture contains the named range `Sales` and the four deterministic object entries:

- `Tour Name Box Chart`
- `Tour Name Box Picture`
- `Tour Name Box Shape`
- `Tour Name Box Text Box`

The Avalonia capture opens the production Name Box popup and uses the same item-producing planner and names. Its
capture-only visual is used because the desktop offscreen renderer does not paint the native Avalonia `Popup` child
when rendered directly; the live popup remains the production interactive control. Its capture fixture uses distinct
`680...` object ids, while the Wave68 physical-selection fixture remains unchanged with its `670...` ids.

## Evidence

Fresh same-size captures were generated and inspected:

- WPF: `artifacts/wave69-wpf/popup.nameBoxDropdown.png`, `208x136`, 5,450 bytes.
- Avalonia: `artifacts/wave69-avalonia/popup.nameBoxDropdown.png`, `208x136`, 3,308 bytes.
- Paired report: `artifacts/wave69-namebox-report/parity-report.html`.
- Pixel diff: `8.9482%`, classified `Chrome`/informational because this is a popup chrome surface; both sides were present and the pair contract passed.

The inspected images show the same five rows and popup frame. The remaining difference is primarily text rasterization
and platform rendering, not missing content or a size mismatch.

## Verification

- `FreeX.App.Avalonia.Tests`: focused open-popup capture test passed.
- `FreeX.ParityCompare.Tests`: three Name Box pair-contract tests passed.
- `FreeX.App.Host.Tests`: three WPF/Avalonia source guards passed.
- Managed WPF parity capture completed with `115/116` surfaces captured; the one unrelated missing surface remains outside this slice.
- Managed paired comparison returned `RESULT: PASS`; no hard regressions were introduced.

Docker/X11 physical execution remains with the parent integration lane. No Wave68 object-selection behavior was changed.
