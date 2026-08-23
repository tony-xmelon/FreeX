# Avalonia Parity Wave 187: FreeW Legal Notices

Date: 2026-08-23  
Scope: FreeW Legal Notices dialog, six canonical states at 620 x 600 logical pixels  
Authority: FreeW WPF `SharedLegalNoticesDialog`

## Pinned canonical baseline

The acceptance baseline supplied for this slice is the committed canonical comparison
input. It contains six genuine visual mismatches and 351,428 changed pixels:

| State | Changed pixels | Changed ratio | Mean channel delta | Dimensions | Classification |
| --- | ---: | ---: | ---: | --- | --- |
| `legal-notices.initial` | 34,120 | 9.172043% | 10.262134 | 620x600 | genuine-visual-mismatch |
| `legal-notices.tab-project-license` | 34,120 | 9.172043% | 10.262134 | 620x600 | genuine-visual-mismatch |
| `legal-notices.tab-legal-notices` | 73,751 | 19.825538% | 21.539183 | 620x600 | genuine-visual-mismatch |
| `legal-notices.tab-privacy-notice` | 68,231 | 18.341667% | 19.682713 | 620x600 | genuine-visual-mismatch |
| `legal-notices.tab-third-party-license-texts` | 70,298 | 18.897312% | 21.189105 | 620x600 | genuine-visual-mismatch |
| `legal-notices.tab-third-party-notices` | 70,908 | 19.061290% | 21.224735 | 620x600 | genuine-visual-mismatch |
| **Aggregate** | **351,428** | - | - | **6 x 620x600** | **6 genuine mismatches** |

## Change

When the read-only document actually overflows, Avalonia now reserves one additional
trailing pixel in the document host. This matches the WPF scrollbar/content registration
for long notices while leaving the compact two-pixel margin used by short notices
unchanged. The existing route-local grayscale antialiasing, 12.1px text compensation,
shared tab chrome, notice content, focus behavior, and automation contract are unchanged.

## Fresh paired evidence

Fresh route-local captures were produced from this checkout with the WPF and Avalonia
harnesses at the same 620x600 target size. The fresh WPF capture is intentionally kept
separate from the pinned canonical image inputs; capture rasterization is not committed,
so the two baselines must not be combined as though they were one pixel-for-pixel run.

| State | Fresh before changed | Fresh after changed | Fresh before mean | Fresh after mean | Dimensions | Classification after |
| --- | ---: | ---: | ---: | ---: | --- | --- |
| `legal-notices.initial` | 31,315 | 31,315 | 9.182707 | 9.182707 | 620x600 / 620x600 | genuine-visual-mismatch |
| `legal-notices.tab-project-license` | 31,330 | 31,330 | 9.192301 | 9.192301 | 620x600 / 620x600 | genuine-visual-mismatch |
| `legal-notices.tab-legal-notices` | 70,063 | 69,854 | 21.164082 | 21.164362 | 620x600 / 620x600 | genuine-visual-mismatch |
| `legal-notices.tab-privacy-notice` | 62,085 | 61,896 | 18.281565 | 18.281845 | 620x600 / 620x600 | genuine-visual-mismatch |
| `legal-notices.tab-third-party-license-texts` | 67,053 | 66,659 | 20.173847 | 20.174126 | 620x600 / 620x600 | genuine-visual-mismatch |
| `legal-notices.tab-third-party-notices` | 64,248 | 63,882 | 19.066077 | 19.058456 | 620x600 / 620x600 | genuine-visual-mismatch |
| **Aggregate** | **326,094** | **324,936** | - | - | **6 x 620x600** | **6 genuine mismatches** |

The accepted route-local result removes 1,158 changed pixels from the fresh paired
capture, with all four long tabs improving and both short states unchanged within the
capture repeatability envelope. No semantic difference, content difference, focus
difference, or classification change was introduced. The remaining mismatch is still
dominated by WPF ClearType versus Skia glyph rasterization, native tab and scrollbar
templates, and framework-specific text layout.

## Verification

- Avalonia Legal Notices visual and WPF-authority tests: 32/32 passed.
- WPF and Avalonia dialog harness Release builds: 0 warnings, 0 errors.
- Final route capture: WPF 6/6 and Avalonia 6/6 captured and content-gated.
- Canonical comparison refresh: 512 scenarios, 221 WPF captures, 291 Avalonia captures;
  141 genuine visual mismatches, 80 passes, and 70 Avalonia extensions.

Next residual: the remaining FreeW Legal Notices glyph/template raster mismatch; the
next distinct visual family is the classified `legal-notices` tail followed by the
remaining font, pagination, drawing/object, chart, table, and WordArt rows.
