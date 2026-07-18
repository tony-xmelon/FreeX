# FreeP bullets autofit Aptos-to-Arial probe rejected - 2026-07-18

## Scope

Fresh current-main evidence for `17-bullets-autofit.pptx` shows the eight
paragraph 18pt Aptos `a:noAutofit` body has matching line cadence but taller
WPF ink bands. Because Aptos is not installed on this host, a narrowly guarded
WPF probe mapped only that exact body signature to installed Arial for both
measurement and painting. All other text routes, the title, and Avalonia were
unchanged.

## Matched evidence

At 1280x720 against the same fresh PowerPoint COM export:

| WPF metric | Current baseline | Arial probe |
| --- | ---: | ---: |
| Slide 1 title control | 1.0498% | 1.0498% |
| Slide 2 whole page | 3.2245% | 4.8240% |

The raw baseline bands were PowerPoint `20/16` pixels for the first/second
wrapped lines and WPF `24/18`; the Arial substitution did not provide a valid
font-raster match and materially worsened the complete target slide.

## Conclusion

The residual is not solved by replacing WPF's implicit Aptos fallback with
Arial. The probe was reverted. Future work needs a font-aware WPF raster path
or a layout-preserving rendering strategy rather than another broad font
family substitution or vertical scale.

## Verification

- Fresh `--avalonia-compare` export completed 2/2 PowerPoint slides.
- Candidate FreeP render completed 2/2 slides.
- Candidate source was reverted; the worktree is back to the accepted renderer
  source apart from the pre-existing `surface-catalog.json` edit.
