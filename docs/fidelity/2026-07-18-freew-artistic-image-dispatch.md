# Artistic Image Dispatch

## Scope

Imported images with an artistic effect but no brightness, contrast, saturation,
transparency, or recolor adjustment were decoded directly by both WPF image
routes. `ImageAdjustHelper` already implements the artistic pixel pipeline, but
the floating and inline callers did not include `HasArtisticEffect` in their
dispatch condition.

## Change

Both image render routes now invoke `ImageAdjustHelper.Apply` when an artistic
effect is present. The helper remains responsible for deciding the effect order
and leaves neutral images on their existing decode path.

## Matched Word Evidence

The persistent Word PNG baseline was reused; no competing COM export was
started. Fresh Release composite renders at 816x1056 produced:

| Fixture | Measurement | Before | After |
| --- | --- | ---: | ---: |
| `drawing-objects-complex` | Whole page | 7.7439% | 7.6095% |
| `drawing-objects-complex` | Floating image/effect region | 20.4920% | 19.2820% |
| `drawing-objects-complex` | Image body | 29.6418% | 27.5786% |
| `drawing-objects-complex` | Reflection | 24.6710% | 21.7532% |
| `object-format-position-size-style` | Whole page | 6.2117% | 6.1948% |
| `object-format-position-size-style` | Image body | 15.6489% | 15.2188% |

These are the two corpus fixtures that author `GlowDiffused`; both improve.

## Verification

`FloatingImage_ArtisticEffectRunsPixelPipelineWithoutOtherAdjustments` passed
both the compiling and `--no-build` runs. The Release fidelity renderer build
completed with zero warnings and zero errors.
