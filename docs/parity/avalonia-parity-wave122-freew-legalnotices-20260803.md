# Avalonia Parity Wave122: FreeW Legal Notices Evidence

Date: 2026-08-03
Scope: FreeW Avalonia Legal Notices, four long-document paired states
Decision: evidence-only correction; no product or test changes retained

## Fresh Windows-host baseline

Fresh current-source WPF and Avalonia captures were taken at 620x600 and 96 DPI
before the rejected experiments. All four pairs captured successfully and were
classified as genuine visual mismatches. Visual inspection found the structure,
wrap points, tabs, viewport, scrollbar, focus border, and Close button already
nearly identical. The changed-pixel score is dominated by WPF ClearType versus
Avalonia/Skia glyph rasterization and anti-aliasing.

| State | Changed pixels | Mean channel delta |
| --- | ---: | ---: |
| `tab-legal-notices` | 18.0078% | 18.7302 |
| `tab-privacy-notice` | 16.6820% | 18.6744 |
| `tab-third-party-notices` | 17.8317% | 19.1904 |
| `tab-third-party-license-texts` | 18.1909% | 20.0279 |

Baseline report: `artifacts/wave122-freew-legal-baseline/comparison/freew_dialog_visual_comparison.{json,html}`.

After restoring `HEAD`, a second current-source Avalonia run reproduced the same four
rows exactly. Its report is retained at `%TEMP%/FreeW-Wave122-CurrentWindows-20260803/comparison/`.

## Rejected experiments

The proposed Avalonia `12.4` font-size and `3,0,3,0` text-host margin were
captured and rejected. The four changed-pixel results were, in the same order,
`18.9522%`, `15.3108%`, `18.8710%`, and `18.3116%`; three of four states worsened.
The geometry-only `3,0,3,0` margin experiment was also rejected: `18.7161%`,
`16.5804%`, `18.4401%`, and `18.4895%`. The product and test files were restored
completely to the Wave121 baseline; no constants or expectations from either
experiment remain.

Candidate reports are retained locally under:

- `artifacts/wave122-freew-legal-after/comparison/`
- `artifacts/wave122-freew-legal-geometry/comparison/`

## Linux evidence

The production Ubuntu 24.04 Docker/Xvfb FreeW smoke started successfully at 1280x820
and 96 DPI. Help > Legal Notices opened, the Legal Notices long-document tab was
selected, and the result was captured at:
`artifacts/linux-interactive-wave122/freew/sessions/20260803T081027694Z/wave122-smoke/legal-notices-tab.png`.

The same-size Linux Avalonia harness captured all four routes, 4/4, with no blank
or unsupported frames. Compared with the fresh WPF authority, Linux measured:

| State | Changed pixels | Mean channel delta |
| --- | ---: | ---: |
| `tab-legal-notices` | 21.4728% | 22.4644 |
| `tab-privacy-notice` | 19.4895% | 19.7729 |
| `tab-third-party-notices` | 20.9642% | 21.8148 |
| `tab-third-party-license-texts` | 20.8110% | 22.2277 |

Linux route captures are under:
`artifacts/linux-interactive-wave122/freew/sessions/20260803T081027694Z/linux-legal-captures/`.
The short-path comparison report used for metric calculation is in
`%TEMP%/FreeW-Wave122-LinuxEvidence/comparison/`.

Fontconfig reports `Consolas -> DejaVu Sans Mono` in the Ubuntu image. No
redistributable Windows Consolas asset is present in the repository, so changing
the requested font family to an unproven Linux substitute would alter product
typography without evidence of closer WPF parity. The remaining visual delta is
therefore recorded as a native font-rasterization limitation, not hidden by a
threshold or reclassified as a pass.

## Verification

- WPF harness Release build: passed, 0 warnings, 0 errors.
- Avalonia harness Release build after reverting the experiments: passed, 0 warnings, 0 errors.
- Avalonia `LegalNoticesDialogVisualParityTests`: 12/12 passed after the final restore.
- WPF `FreeWHelpInfoTests`: 9/9 passed after the final restore.
- Current-source Windows Avalonia rerun: 4/4 captured and reproduced the baseline metrics exactly.
- Linux Avalonia harness: 4/4 captured, 0 unsupported.
- Product/test source diff after restore: empty; this note is the only retained change.
