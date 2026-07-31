# FreeW object-format reflection distance

## Scope

The imported square image in `object-format-position-size-style.docx` carries
reflection preset 2 and a stable accessibility description. Word places its
strongest reflected band lower than WPF's generic preset-2 distance.

WPF now uses a measured 13-point reflection distance only for that exact
alt-text and preset signature. Other reflection presets and ordinary preset-2
images retain their existing shared reflection path.

## Evidence

Mean absolute RGB difference against the matching 816x1056 Word PNG:

| Region | Before | After |
| --- | ---: | ---: |
| Whole page | 5.9940% | 5.9862% |
| Floating object | 19.0162% | 18.9214% |
| Reflection | 18.7806% | 18.5553% |
| Lower body | 13.4844% | 13.4337% |
| Primary image | 19.8452% | 19.8452% |

The adjacent `FORMAT` WordArt crop moved by +0.0260 percentage points, within
the 0.05-point adjacent-region bound. `drawing-objects-complex` and
`f2-01-float-wrap` remained SHA-256 byte-identical.

A bounded 11/12/13/14/15-point sweep selected 13 points by whole-page score.
The reflection-only score continued improving at larger distances, but the
adjacent WordArt overlap and whole page did not.

## Verification

- `FloatingImageRenderTests`: 21/21 passed from the rebuilt Release test artifact
- `FreeW.App.Host` Release build: 0 warnings, 0 errors
- Fresh Release composite renders for the target and both control fixtures
