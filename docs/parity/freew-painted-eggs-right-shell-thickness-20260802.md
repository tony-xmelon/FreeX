# FreeW Painted Eggs right-shell thickness (2026-08-02)

## Scope

After mottle, apex, and pedestal calibration, the imported `eggsBlack` motif still
had a heavy right shell. The isolated egg had 30 near-black pixels in its right edge
band while Word had 10; total FreeW ink was already lower than Word, ruling out a
global inner-shell expansion. The shared planner now moves only the four right-side
white-interior vertices outward by one DIP. All other shell, pedestal, mottle, cadence,
and placement geometry remains unchanged.

## Matched reference

- Fixture: `eggs.docx`, SHA-256
  `CE272D4E133F03C80EF456042A3F4D148E1D2B72ACE144898BD1B77E7D747601`
- Fresh Word COM PNG: 816x1056, SHA-256
  `E592B57C4722541EE45028570A0FD88F9E17CD6232AF37D78A852C836308D6CD`
- Before WPF composite PNG: 816x1056, SHA-256
  `EDAF00BF2562A11DD691020E925DE925AF73C1D51DA7EBEF5A39AAE0F41C843C`
- Candidate WPF composite PNG: 816x1056, SHA-256
  `838AE6069BB010EC6C65B3BFACF98460D7434A621E887B902F5052A71D4DF389`

The Word PNG and before-candidate hashes exactly match the preceding accepted pedestal
slice. Word COM exported one document and one page and quit its owned process cleanly.

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 4.262332% | 4.087260% | -0.175072 pp |
| Top border | 10.310482% | 9.901416% | -0.409065 pp |
| Bottom border | 8.418957% | 8.017229% | -0.401729 pp |
| Left border | 8.137952% | 7.776284% | -0.361668 pp |
| Right border | 7.886454% | 7.518282% | -0.368172 pp |
| Isolated top egg | 23.704567% | 22.638092% | -1.066475 pp |
| Right-shell ROI | 18.995841% | 10.671420% | -8.324421 pp |
| Interior control | 0.573890% | 0.573890% | 0.000000 pp |

## Verification

- `PageBorderArtVisualPlannerTests`: 19/19
- WPF decorative page-border consumer source contract: 1/1
- Avalonia live/PDF consumer and Painted Eggs PDF raster contracts: 2/2
- Avalonia PDF black-ink interval tightened to 228-238 pixels; actual 233
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh isolated Word COM export: 1/1 document, 1/1 page

## Process note

Compare directional edge-band ink separately from total motif ink before expanding an
inner mask. A local dark excess does not justify a global shell change when total ink
is already low. Adjust only the owning contour vertices and require all edge ROIs plus
the whole page to improve with interior content unchanged.
