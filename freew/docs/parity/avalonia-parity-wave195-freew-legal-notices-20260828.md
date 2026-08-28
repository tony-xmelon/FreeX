# FreeW Legal Notices Wave 195

The FreeW Avalonia Legal Notices wrapper now applies a one-pixel trailing margin to the realized selected-content presenter after the shared tab template has rendered. This matches the WPF tab pane's trailing edge while keeping the correction local to FreeW Legal Notices.

The six route scenarios were recaptured from commit `e2afdfb257` and compared against the retained WPF authority capture with the canonical route-local `legal-notices` refresh. The WPF authority manifest remained unchanged at SHA-256 `0F63BA1642D0477057ABF5F20B2050D205E121CC89B6F26C8B9196458A4225EC`. Against the previously tracked canonical rows, the refresh reduced the aggregate changed-pixel count by 683 pixels, from 324,936 to 324,253. Row metrics are below; negative deltas are improvements.

| Scenario | Before changed / ratio | After changed / ratio | Delta |
| --- | ---: | ---: | ---: |
| `legal-notices.initial` | 31,315 / 8.4180% | 31,476 / 8.4613% | +161 |
| `legal-notices.tab-legal-notices` | 69,854 / 18.7780% | 69,855 / 18.7782% | +1 |
| `legal-notices.tab-privacy-notice` | 61,896 / 16.6387% | 65,093 / 17.4981% | +3,197 |
| `legal-notices.tab-project-license` | 31,330 / 8.4220% | 31,491 / 8.4653% | +161 |
| `legal-notices.tab-third-party-license-texts` | 66,659 / 17.9191% | 66,445 / 17.8616% | -214 |
| `legal-notices.tab-third-party-notices` | 63,882 / 17.1726% | 59,893 / 16.1003% | -3,989 |

All 285 non-`legal-notices.*` rows were structurally unchanged. The remaining Legal Notices residual is primarily native glyph rasterization and the remaining tab-template/text-edge differences.
