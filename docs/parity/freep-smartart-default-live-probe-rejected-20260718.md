# FreeP SmartArt default live-layout probe rejected - 2026-07-18

## Scope

Fresh PowerPoint COM capture of `14-smartart-live.pptx` isolated slide 4,
`SmartArt Live - List`. Its package declares the Office `layout/default`
definition with list category metadata, but the cached `drawing4.xml` contains
four visible rectangles arranged by the package's two-column snake algorithm
plus one empty placeholder. FreeP currently leaves this `default` definition
on the cached-drawing path.

The first source probe added `default` to the list allow-list, but all four
slides were byte-identical because the reader's family classifier did not
classify `/layout/default`. An effective follow-up probe admitted that exact
signature to the List family and live-layout allow-list, exercising the
generic vertical `LayoutList` renderer.

## Matched evidence

| Slide / host | Cached baseline | Generic live probe |
| --- | ---: | ---: |
| WPF slide 1 control | 1.3477% | 1.3477% |
| WPF slide 2 control | 1.2514% | 1.2514% |
| WPF slide 3 control | 0.4024% | 0.4024% |
| WPF slide 4 target | 1.3412% | 22.5894% |
| Avalonia slide 4 target | 1.8098% | 0.3585% |
| WPF four-slide average | 1.0857% | 6.3977% |
| Avalonia four-slide average | 1.0818% | 0.7189% |
| Avalonia vs PowerPoint average | 1.1072% | 6.4045% |

The full four-slide sequence was freshly exported by PowerPoint for both
captures. The generic live probe was reverted. Although Avalonia's shared
live path improved its slide-4 score, WPF regressed catastrophically and the
two hosts no longer shared a valid layout owner.

## Process rule

When a SmartArt package supplies a cached drawing for an Office layout whose
algorithm is not implemented, classify and admit it only after reproducing
the package geometry for both hosts. A family label or a plausible live
renderer is not enough; preserve the cached path until target, complete
sequence, and cross-host controls all improve.

## Verification

- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors for the probe.
- Fresh PowerPoint COM export: 4/4 slides for baseline and probe.
- Product source restored to the cached-drawing baseline; no product change
  was accepted.
