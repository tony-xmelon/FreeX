# FreeW Column Rule Raster Parity -- 2026-07-28

## Scope

`f2-columns.docx` uses two equal columns with `w:cols/@w:sep`. Its body layout and
line positions already match Word closely, but WPF's native `FlowDocument` column rule
rasterizes a one-DIP rule across two half-covered gray pixels. Word emits one opaque
black pixel at the gap center.

The paginated print, section-aware print, fidelity-composite, and continuous editable
paths now suppress the native FlowDocument rule and use the same pixel-aligned Word-style
rule instead. The interactive editor consumes it through a non-hit-testable adorner driven
by the existing pagination break engine, leaving editable column flow unchanged.

## Evidence

Reference: direct Microsoft Word COM PDF export, rasterized at 96 DPI to an 816 x 1056
PNG. Candidate and baseline use the same fixture and rebuilt Release composite artifact.

| Metric | Before | After |
|---|---:|---:|
| Whole page mean RGB delta | 4.3033% | 4.2031% |
| Column-rule ROI `(400,90)-(416,965)` | 6.1714% | 0.0071% |
| Left text-column ROI `(90,90)-(400,960)` | 7.0349% | 7.0349% |
| Right text-column ROI `(416,90)-(730,960)` | 6.3123% | 6.3123% |

Raw center pixels confirm the ownership: Word uses black only at `x=408` over
`y=96..959`; the candidate reproduces that one-pixel band. The old WPF rule painted
gray at both `x=407` and `x=408`.

## Verification

- `dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release --no-restore` -- 0 warnings, 0 errors.
- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~VisualEvidenceFidelityRenderSourceTests|FullyQualifiedName~ColumnLayoutTests" --logger "trx;LogFileName=column-rule-tests.trx"` -- 20/20 passed.
- A hosted STA regression test places a two-column `DocumentView` in an `AdornerDecorator` and
  verifies that exactly one non-hit-testable `ColumnRuleAdorner` is active while the underlying
  `FlowDocument.ColumnRuleWidth` remains zero; a `RenderTargetBitmap` capture verifies a black
  divider pixel at the Word-matched `x=408, y=500` location.
- Fresh `f2-columns.docx` composite render completed from the rebuilt Release artifact.

## Guard

Keep rule geometry separate from column flow. The rejected black-native-rule probe changed
only coverage and left the whole-page score unchanged; the rejected one-DIP gap expansion
reflowed both columns and regressed the whole page from 4.3033% to 8.7468%.
