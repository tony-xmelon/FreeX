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

It writes `report.json` and `report.md` beneath the chosen output directory.
Only fixed-width pairs (`1100`, `900`, and `750`) receive a metric. The tool
rescales the two top-band images to their shared logical viewport using the
manifest DPI metadata before calculating the mean RGB absolute delta. It does
not letterbox, crop, or silently compare unequal maximized windows.

## Current mapping and limits

| Scope | Excel reference | FreeX WPF | FreeX Avalonia | Treatment |
|---|---|---|---|---|
| Ribbon, 1100/900/750 logical widths | 27 complete rows | Matching top-band rows | No foreground desktop/ribbon capture contract | Provisional WPF image triage only; Avalonia explicitly unmatched. |
| Ribbon, maximized width | 9 complete rows | 9 complete rows at another maximized viewport | No foreground desktop/ribbon capture contract | Coverage-only; no metric because the viewports differ. |
| Draw ribbon | Captured at all four widths | Existing WPF Draw rows | No foreground desktop/ribbon capture contract | Included in the 27 fixed-viewport triage rows and nine maximized coverage-only rows. |
| Office popups and native dialogs | Six retained Excel tours | Historical WPF tours | No same-viewport Avalonia foreground artifacts | Coverage evidence only. Element/window crops are not a common rectangle, so a full-image pixel delta would be misleading. |

The canonical Avalonia visual manifests contain 94 deterministic dialog
surfaces, but they intentionally do not contain an operating-system desktop
title bar, Excel-equivalent ribbon top band, or foreground popup rectangle.
The comparison tool reports zero Avalonia app-chrome rows rather than inventing
a WPF-to-Avalonia or Excel-to-Avalonia measurement.

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

1. Recapture the WPF ribbon at the same foreground session and width matrix,
   then rerun this report to establish a same-session WPF comparison.
2. Add an Avalonia Windows foreground capture mode that emits the same
   `ribbon:<width>:<tab>` pair keys and the same logical width/height metadata.
   Only then add an Excel-to-Avalonia pixel comparison.
3. Give popup/dialog capture contracts a shared client rectangle before using
pixel deltas for them; the present crops establish coverage, not geometry.

## First reproducible triage run (2026-08-16)

Against the retained 36-row Excel foreground matrix and the existing 36-row
WPF keyed matrix, the command produced 27 fixed-viewport provisional rows with
a 17.059% mean RGB delta and a 17.802% maximum. Nine maximized-window rows
were correctly held as coverage-only. The Draw rows are now included across
all widths. These values are a review queue baseline, not an acceptance
threshold: the WPF source images predate the Excel run.
