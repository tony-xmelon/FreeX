# Avalonia parity Wave69: FreeW Font and Paragraph dialogs

This replacement slice targets the ten canonical FreeW Font and Paragraph dialog states that
remained genuine visual mismatches after Wave68. The WPF capture is the authority. The comparison
threshold and classifications were unchanged.

## Scope

- FreeW Avalonia Font and Paragraph production dialog surfaces only.
- FreeW Avalonia focused visual-parity tests.
- FreeW Avalonia dialog visual harness capture metadata and evidence.
- No shared, FreeX, or FreeP files were edited.

## Implementation

- Added FreeW-local Fluent template compensation for the Font and Paragraph dialog text fields.
  The painted `PART_BorderElement` is constrained to the WPF 18 px one-line field, uses the WPF
  input/focus border colors, and inherits the dialog foreground and authority font.
- Replaced the compact dialog checkbox template in this family with the measured WPF 14 px
  indicator and spacing while retaining three-state and keyboard behavior.
- Set dialog text rendering to grayscale antialiasing so Avalonia captures use the same grayscale
  text treatment as WPF `RenderTargetBitmap` evidence.
- Corrected the Font action-row right edge and the Paragraph indents/breaks content margins from
  paired pixel geometry. Explicit `Segoe UI` remains the dialog authority font declaration.
- Added runtime template assertions for the painted field and checkbox geometry.

## Evidence

The exact metrics are preserved in the tracked
`docs/parity/avalonia-parity-wave69-freew-font-paragraph-20260730-metrics.json` metadata file.
The focused capture bundle was generated under `artifacts/freew-wave69-font-paragraph-20260730`
during validation.
`baseline/wpf` is the fresh pre-edit WPF authority capture; `final-current/avalonia` is the
post-edit Avalonia capture; `final-current/compare` is the paired report and heatmap bundle.

| State | Before changed | After changed | Before mean | After mean | Before pHash | After pHash |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `font.initial` | 12.932% | 11.246% | 11.57 | 10.13 | 2 | 2 |
| `font.populated` | 13.049% | 11.340% | 11.74 | 10.26 | 2 | 2 |
| `font.tab-advanced` | 12.659% | 12.107% | 10.83 | 10.48 | 1 | 1 |
| `font.tab-font` | 12.941% | 11.246% | 11.60 | 10.13 | 2 | 2 |
| `font.validation-error` | 13.226% | 11.510% | 11.99 | 10.53 | 2 | 2 |
| `paragraph.initial` | 9.769% | 8.500% | 10.88 | 9.58 | 1 | 2 |
| `paragraph.populated` | 9.769% | 8.500% | 10.88 | 9.58 | 1 | 2 |
| `paragraph.tab-indents-and-spacing` | 9.769% | 8.500% | 10.88 | 9.58 | 1 | 2 |
| `paragraph.tab-line-and-page-breaks` | 8.403% | 8.235% | 10.53 | 11.02 | 4 | 5 |
| `paragraph.validation-error` | 10.400% | 9.235% | 11.57 | 10.40 | 1 | 2 |

Route averages improved from 12.962% to 11.490% changed pixels and from 11.55 to 10.31 mean
delta for Font. Paragraph changed pixels improved from 9.622% to 8.594% and mean delta from 10.95
to 10.03. All ten rows remain genuine mismatches; this slice does not claim pixel parity.

## Verification

- WPF focused capture: 10/10 captured.
- Avalonia focused capture: 10/10 captured.
- Paired comparison: 10/10 genuine visual mismatches; zero unsupported or invalid-content rows.
- Focused Avalonia tests: 21 passed, 0 failed, 0 skipped.
- Avalonia dialog harness Release build: 0 warnings, 0 errors.

## Residuals

The remaining differences are primarily Skia versus WPF text rasterization and native Fluent versus
WPF template details. `paragraph.tab-line-and-page-breaks` has a lower changed-pixel ratio but a
small mean/pHash regression after the WPF-sized checkbox geometry; it remains honestly visible in
the report for a later targeted typography pass. No threshold, evidence gate, or classification was
weakened.
