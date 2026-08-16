# FreeX / Excel app-chrome comparison

This lane turns retained Excel and FreeX foreground captures into an explicit,
reproducible Office-vs-app-chrome report. It is deliberately separate from the
cross-platform WPF/Avalonia screenshot dashboard: capture coverage, pixel
triage, and visual-parity acceptance are different facts.

## Command

```powershell
dotnet run --project tools/FreeX.ExcelChromeCompare --configuration Release -- --out artifacts/parity/freex-excel-chrome
```

The command is read-only with respect to the capture inputs. It reads:

- Excel foreground ribbon evidence: `tools/screenshots_excel/screenshot_manifest.json`
- FreeX WPF foreground ribbon evidence: `tools/screenshots/screenshot_manifest.json`
- FreeX Avalonia Windows foreground ribbon evidence:
  `tools/screenshots_avalonia_ribbon/screenshot_manifest.json`

It writes `report.json` and `report.md` beneath the chosen output directory.
Only fixed-width pairs (`1100`, `900`, and `750`) receive a metric. The tool
rescales the two top-band images to their shared logical viewport using the
manifest DPI metadata before calculating the mean RGB absolute delta. It does
not letterbox, crop, or silently compare unequal maximized windows.

## Current mapping and limits

| Scope | Excel reference | FreeX WPF | FreeX Avalonia | Treatment |
|---|---|---|---|---|
| Ribbon, 1100/900/750 logical widths | 27 complete rows | Matching foreground top-band rows | Matching contract provided by `tools/screenshot_ribbon_avalonia.ps1`; no trusted run retained yet | Measure each shell only after its complete guarded foreground matrix exists. |
| Ribbon, maximized width | 9 complete rows | 9 complete rows at another maximized viewport | Same planned contract | Coverage-only; no metric because maximized viewports differ. |
| Draw ribbon | Captured at all four widths | Existing WPF Draw rows | Included in the Avalonia nine-tab matrix contract | Capture every framework at all widths before comparison. |
| Office popups and native dialogs | Six retained Excel tours | Historical WPF tours | No same-viewport Avalonia foreground artifacts | Coverage evidence only. Element/window crops are not a common rectangle, so a full-image pixel delta would be misleading. |

The canonical Avalonia visual manifests contain 94 deterministic dialog
surfaces, but they intentionally do not contain an operating-system desktop
title bar, Excel-equivalent ribbon top band, or foreground popup rectangle.
The new foreground harness is intentionally separate from that deterministic
corpus: it launches the Windows Avalonia host, checks process/title foreground
ownership before every input and screenshot, and writes the same
`ribbon:<width>:<tab>` keys and logical viewport metadata as the Excel/WPF
lanes. The comparison tool refuses to load a missing Avalonia foreground
manifest rather than treating the dialog corpus as app-chrome evidence.

## Reading the report

`provisional-pixel-comparison` means the pair has a shared fixed logical
viewport and a reproducible delta. It does **not** mean pass, fail, or Office
equivalence; the currently retained WPF ribbon images predate the refreshed
Excel run and must be recaptured before any acceptance threshold is set.

`coverage-only` identifies a real pair whose images are not geometrically
comparable, such as maximized windows. `source-skipped` is reserved for a
future unavailable tab; the current 36-row run has no skipped tab. Neither
status is a pass.

## Next evidence needed

1. From an unlocked interactive Windows desktop, run
   `tools/screenshot_ribbon.ps1 -Widths max,1100,900,750` and
   `tools/screenshot_ribbon_avalonia.ps1 -Widths max,1100,900,750`.
   Both commands discard a partial matrix and retain a blocker manifest when
   anything other than their expected app owns foreground.
2. Run `FreeX.ExcelChromeCompare` after both manifests exist. It measures both
   WPF and Avalonia fixed widths independently against Excel and retains the
   maximized rows as coverage-only.
3. Give popup/dialog capture contracts a shared client rectangle before using
pixel deltas for them; the present crops establish coverage, not geometry.

## First reproducible triage run (2026-08-16)

Against the retained 36-row Excel foreground matrix and the existing 36-row
WPF keyed matrix, the original command produced 27 fixed-viewport provisional
rows with a 17.059% mean RGB delta and a 17.802% maximum. Nine
maximized-window rows were correctly held as coverage-only. These values are a
historical review queue baseline, not an acceptance threshold.

## Runtime capture blocker — 2026-08-16

The Release WPF capture host was rebuilt and a foreground run was attempted.
The guard rejected the run before selecting a tab because `Windows Default
Lock Screen` (PID 14536) owned foreground instead of the launched WPF host.
The script discarded the partial output; the pre-existing committed WPF matrix
was restored unchanged. No Avalonia capture was attempted while that same
desktop blocker remained active. The next action is strictly an unlocked
desktop rerun of the two commands above; no synthetic or headless image may be
used to fill this foreground evidence gap.
