# FreeW Painted Eggs first-mottle registration (2026-08-02)

## Scope

After the accepted shell and pedestal corrections, the first top mottle in imported
`eggsBlack` remained two pixels left of Word's corresponding mask. The shared planner
now translates only that patch +2 DIPs on X. Its accepted 0.70 scale, the other five
mottles, shell, pedestal, cadence, and placement geometry remain unchanged.

## Matched reference

- Fixture: `eggs.docx`, SHA-256
  `7BF83CF7298E56044CB2E09177BD818E9A72FBC4E880F7DD2C716653D6F5A964`
- Fresh Word COM PNG: 816x1056, SHA-256
  `31F0800881946F8804D85EE5FBE44410B48A9A5881E336DFD9D588ADDB15D65B`
- Before WPF composite PNG: 816x1056, SHA-256
  `ED7726773E73D5A2C855F9C3808959B665F03DED13794E79F840905A3A64D120`
- Candidate WPF composite PNG: 816x1056, SHA-256
  `EB37881FB0D10652B890DB23B277B01B89EFDEE14C84572AB6E02ACC56DB4EA7`

Word COM exported one document and one page from the exact fixture and quit its owned
process cleanly. The candidate used the rebuilt Release WPF composite renderer.

## Visual result

Mean absolute RGB delta against the unchanged Word PNG:

| Region | Before | After | Change |
| --- | ---: | ---: | ---: |
| Whole page | 4.065926% | 4.004471% | -0.061455 pp |
| Top border | 13.606523% | 13.410260% | -0.196263 pp |
| Bottom border | 13.443280% | 13.269953% | -0.173327 pp |
| Left border | 12.606632% | 12.353162% | -0.253470 pp |
| Right border | 12.521339% | 12.252071% | -0.269267 pp |
| Isolated top egg | 28.555453% | 28.115043% | -0.440411 pp |
| First-mottle ROI | 42.205287% | 40.379455% | -1.825832 pp |
| Interior control | 0.573890% | 0.573890% | 0.000000 pp |

## Verification

- `PageBorderArtVisualPlannerTests`: 19/19
- WPF decorative page-border consumer source contract: 1/1
- Avalonia live/PDF consumer and Painted Eggs PDF contracts: 2/2
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors
- Fresh isolated Word COM export: 1/1 document, 1/1 page

## Rejected probe

Expanding both top mottles from 0.70 to 0.85 improved the local ROI and horizontal
edges, but regressed the left border by 0.033064 pp and the right border by 0.035674
pp. It was reverted. A size mismatch in one placement raster was not enough evidence
for a shared scale change.

## Process note

Rank local mask components before changing global patch scale. Prefer translating the
single owning patch when its size contract already passed earlier whole-frame gates,
and require all four edges plus the whole page to improve with interior content stable.
