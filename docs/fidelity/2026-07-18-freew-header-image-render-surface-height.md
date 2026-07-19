# Header Image Render Surface Height

## Scope

The composite fidelity renderer used one 36-DIP surface for both headers and
footers. The first section of `f2-hf-images.docx` has a 40-DIP header bitmap,
so WPF clipped its lower rows before compositing it onto the page.

The header surface is now 42 DIPs. The footer remains on its existing 36-DIP
surface and its placement formula is unchanged.

## Matching Word COM Evidence

Persistent Word COM PNGs and WPF composites are 816 x 1056.

| Page / Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| `f2-hf-images` page 1 whole | 1.1102% | 1.0816% | -0.0286 pp |
| page 1 header `(60,25)-(760,160)` | 2.7104% | 2.4504% | -0.2600 pp |
| `f2-hf-images` page 2 whole/header | 1.1223% / 2.8438% | unchanged | stable |

All three `f2-hf-basic`, both first-page, and both odd/even header pages were
byte-stable. The change only reaches the image-bearing header slot.

## Verification

- `FreeW.FidelityRender` Release build completed with zero warnings and errors.
- Fresh composite renders covered both image pages and all default,
  first-page, and odd/even text-header controls.
