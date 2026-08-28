# FreeW Legal Notices Wave 195

The FreeW Avalonia Legal Notices wrapper now applies a one-pixel trailing margin to the realized selected-content presenter after the shared tab template has rendered. This matches the WPF tab pane's trailing edge while keeping the correction local to FreeW Legal Notices.

The six route scenarios were recaptured and compared against the retained WPF authority capture with the route-local `legal-notices` refresh. The comparison reduced the aggregate changed-pixel count by 5,316 pixels, from 329,584 to 324,268. Row metrics are below; negative deltas are improvements.

| Scenario | Before changed / ratio | After changed / ratio | Delta |
| --- | ---: | ---: | ---: |
| `legal-notices.initial` | 32,378 / 8.7038% | 31,491 / 8.4653% | -887 |
| `legal-notices.tab-legal-notices` | 70,741 / 19.0164% | 69,855 / 18.7782% | -886 |
| `legal-notices.tab-privacy-notice` | 65,977 / 17.7358% | 65,093 / 17.4981% | -884 |
| `legal-notices.tab-project-license` | 32,378 / 8.7038% | 31,491 / 8.4653% | -887 |
| `legal-notices.tab-third-party-license-texts` | 67,331 / 18.0997% | 66,445 / 17.8616% | -886 |
| `legal-notices.tab-third-party-notices` | 60,779 / 16.3384% | 59,893 / 16.1003% | -886 |

All non-`legal-notices.*` row metrics were unchanged. The remaining Legal Notices residual is primarily native glyph rasterization and the remaining tab-template/text-edge differences.
