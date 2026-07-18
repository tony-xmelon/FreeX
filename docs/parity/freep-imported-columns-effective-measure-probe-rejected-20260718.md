# FreeP Imported Columns Effective-Measure Probe

Date: 2026-07-18  
Deck: `20-columns-gradoutline.pptx`  
Baseline source: fresh PowerPoint export at 1280x720  
Renderer: WPF `FreeP.RenderCompare` Release artifact

## Probe

The continuous imported-column path splits text using an Aptos fallback scale of
`0.93`, then renders each fragment with wrapping disabled and a horizontal
transform. The probe made the measurement call use the same disabled-wrap,
scaled effective path instead of measuring at the unscaled column width.

## Result

The source change compiled and was active in a fresh render, but it was rejected:

| Region | Baseline | Candidate |
| --- | ---: | ---: |
| Whole page | 1.0634% | 1.0984% |
| Text box `(45,45)-(410,305)` | 7.8558% | 8.1966% |
| Left column `(50,50)-(230,290)` | 11.5095% | 11.9185% |
| Right column `(245,50)-(405,290)` | 5.3713% | 5.7872% |
| Paragraph-2 crop `(50,145)-(230,225)` | 12.0534% | 13.2981% |
| Gradient outline `(470,40)-(810,310)` | 2.5778% | 2.5778% |

Raw dark-ink bands showed the candidate added a visible fragment band at
`y=188-201` while the following content remained at `y=210-223`; PowerPoint's
corresponding bands are `y=193-204` and `y=215-226`. The apparent blank slot was
therefore not a simple measurement-only gap. The candidate was reverted.

## Process rule

For imported multi-column text, matching the final draw call's wrapping mode in
the measurement pass is not sufficient evidence: the split fragments and the
planner's line heights jointly own the visible cadence. Require raw band
comparison plus whole-page, both-column, paragraph, and non-target shape gates.
