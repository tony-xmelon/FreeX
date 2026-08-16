# FreeX Excel foreground capture — 2026-08-16

This interactive Windows session refreshed the reproducible Excel reference
surfaces used by the FreeX visual-evidence lanes.  These captures document
coverage and reference state; they do not establish pixel-level Excel parity.

## Ribbon matrix

`tools/screenshot_excel.ps1 -Widths max,1100,900,750` completed with a
foreground-owned Excel window at 120 DPI. It retained 36 top-band captures:
the nine tabs exposed by this Office profile (`Home`, `Insert`, `Draw`, `Page
Layout`, `Formulas`, `Data`, `Review`, `View`, and `Help`) at each of the four
widths.

The capture harness now creates a `Blank workbook` before discovering tabs.
The prior `/e` workbook-less launch did not materialize the enabled `Draw`
tab, even though it is selected in Excel's Ribbon customization. The current
manifest has no skipped tabs and includes four `Draw` captures.

Artifacts and metadata: `tools/screenshots_excel/` and
`tools/screenshots_excel/screenshot_manifest.json`.

## Guarded transient surfaces

The tours were executed in the documented order.  Five fixed-name script tours
completed, and the modern UI-Automation capture completed the AutoFilter popup
that the legacy PowerShell popup finder did not locate.

| Surface | Capture result | Artifact location |
|---|---|---|
| Table AutoFilter dropdown | Complete, `Net UI Tool Window`, 333 × 578 | `tools/foreground-captures/excel-autofilter/` |
| Home Number Format | Complete | `tools/screenshots_excel/home-number-format-dropdown-tour/` |
| Home Borders | Complete | `tools/screenshots_excel/home-borders-dropdown-tour/` |
| Worksheet cell context menu | Complete | `tools/screenshots_excel/worksheet-context-menu-tour/` |
| Open workbook dialog | Complete | `tools/screenshots_excel/open-workbook-dialog-tour/` |
| Save As workbook dialog | Complete | `tools/screenshots_excel/save-as-workbook-dialog-tour/` |

The Save As tour remains an Office `NUIDialog` surface in this installation;
it is retained as Office UI evidence, not as a Windows common-dialog claim.

## Paired app-render validation

The deterministic capture hosts were refreshed in a local ignored artifact
directory.  WPF captured 116/116 surfaces.  Avalonia captured 180/181;
`popup.nameBoxDropdown` remains intentionally diagnostic-only because its
authoritative proof requires the separately scoped native popup selector.  All
116 WPF surface identifiers are present in the Avalonia manifest.

## Uniform app-chrome follow-up

`tools/screenshot_ribbon.ps1` (WPF) and the new
`tools/screenshot_ribbon_avalonia.ps1` (Avalonia Windows) now share one
foreground app-chrome contract: the nine static tabs at `max`, `1100`, `900`,
and `750` logical widths, a 300-logical-pixel top band, and
`ribbon:<width>:<tab>` pair keys. Both commands retain only a full 36-state
matrix and verify that their own process/window title owns foreground before
input and screen capture.

The completed current-session run retained 36 WPF and 36 Avalonia foreground
states, including all four Draw widths. The fixed-width comparison has 27
valid WPF-to-Excel rows (13.937% mean / 14.399% maximum RGB delta) and 27
Avalonia-to-Excel rows (15.639% mean / 16.048% maximum); nine maximized rows
remain coverage-only. These are triage metrics, not parity acceptance.

The initial lock-screen/apphost interruptions were resolved without accepting
partial evidence. The WPF apphost now searches the installed global runtime
rather than a stale user-local `DOTNET_ROOT`, and both capture scripts retain
only a complete guarded matrix.
