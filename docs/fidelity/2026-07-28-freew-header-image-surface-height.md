# Header Image Surface Height Fidelity

## Scope

The WPF composite renders header/footer slots into a fixed-height surface before
placing them in the page frame. In the Word-backed `f2-hf-images` fixture, the
left-aligned header image was clipped one pixel early at its lower edge.

## Change

The shared header slot surface is now 43 DIPs rather than 42 DIPs in both the
normal `PageBox` and generated-table continuation-page paths. Footer height and
the measured header text baseline remain unchanged.

## Word Evidence

Microsoft Word exported `f2-hf-images.docx` directly to PDF on 2026-07-28;
the PDF was rasterized at 96 DPI to matched 816x1056 PNGs.

| Page | Region | Before | After |
| --- | --- | ---: | ---: |
| 1 | whole page | 1.3326% | 1.3248% |
| 1 | left header image | 3.7495% | 3.4080% |
| 2 | whole page | 1.2321% | 1.2321% |
| 2 | right header image | 3.5730% | 3.5730% |

The page-1 dark-blue image-frame mask extended from `y=31..72` to `y=31..73`,
toward Word's `y=32..74`. The page-2 right-aligned image, all table-page
header text, body regions, and footer regions were pixel-stable.

## Verification

- Rebuilt `FreeW.FidelityRender` Release with 0 warnings and 0 errors.
- Rendered both header-image pages and all three `table-page-composition-stress`
  pages through the rebuilt composite route.
- Focused source contract: `FidelityRender_UsesTheSharedMeasuredHeaderSurfaceHeight`.
