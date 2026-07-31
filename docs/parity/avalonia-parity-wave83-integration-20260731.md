# Avalonia parity wave 83 integration - 2026-07-31

## Integrated slices

- FreeX row and column header drags retain the pointer-down header as the explicit selection anchor, including formula point-mode directionality, matching WPF after prior Shift selections.
- FreeW Avalonia PDF export retains laid-out header/footer, note, and note-separator regions as shared PDF text and line operations.
- FreeP textless-shape double-clicks continue through normal selection handling in both hosts, while text-bearing shapes still defer to the in-canvas editor and OLE/Zoom gestures keep priority.
- Shared Avalonia ribbon menus preserve authored enabled and checked state, prevent command-state refresh from re-enabling authored-disabled parents, and expose checked items with checkbox toggle semantics.
- FreeP whole-window visual evidence source hashes were refreshed for the shared Avalonia ribbon renderer; the evidence inventory and outcomes did not change.

## Verification

- Focused cross-host slice tests passed 33/33.
- The shared ribbon UI lane passed 28/28.
- Linux physical interaction evidence passed 85/85: FreeX 24/24, FreeW 37/37, and FreeP 24/24. All three manifest contracts passed.
- Repository preflight passed across 124 projects, 89 main-solution entries, and 20 default-test entries.
- `dotnet build FreeX.slnx --configuration Release` passed with 0 warnings and 0 errors.
- The default lane reported 34,544 passed, 29 failed, and 133 skipped. The failures exactly match the existing current-host WPF off-screen bitmap cluster: 26 FreeX print/render assertions and 3 FreeP host-rendering assertions. All Avalonia projects passed.

## Residual status

Wave 83 closes four bounded functional-depth slices without introducing new actionable command-inventory gaps. The overall Avalonia-to-WPF parity goal remains active. The largest measured residual is still FreeW visual fidelity, followed by deeper export/render coverage such as Avalonia PDF tables, images, floating objects, and decorations; subsequent waves should select verified residual behavior from the generated evidence rather than treating command-route coverage as overall completion.
