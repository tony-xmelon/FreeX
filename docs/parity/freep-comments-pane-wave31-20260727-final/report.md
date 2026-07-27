# FreeP Dialog/Pane Paired Visual Evidence

Generated `2026-07-27T13:49:07.8977494+00:00` from real app-owned WPF and Avalonia render targets. Semantic route coverage is not treated as visual parity.

- Scenarios: 28
- Paired captures: 1
- Pass: 1
- Mismatch: 0
- Limitation: 27
- Native Open/Save As: human evidence only; no cross-picker pixel equality assertion.
- Environment: WPF source desktop DPI was 144x144; app-owned rasters were normalized to logical 96 DPI before comparison.
- Environment: Captures include app-owned client content only; native non-client title bars are outside the paired pixel gate.
- Environment: WPF mode: visible-app-owned-render-target; Avalonia mode: visible-app-owned-render-target.

| Scenario | Classification | WPF dimensions | Avalonia dimensions | Nonblank | Focus | Buttons | Enabled state | Target pixel metrics | Shell-context metrics | Paired images |
|---|---|---:|---:|---|---|---|---|---|---|---|
| design.slide-size.initial | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| design.slide-size.invalid | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| insert.header-footer.date-time | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| insert.header-footer.apply-to-all | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| home.find-replace.find | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| home.find-replace.replace | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| insert.hyperlink.initial | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| insert.hyperlink.validation | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| insert.hyperlink.populated | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| chart.edit-data.initial | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| chart.edit-data.validation | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| chart.edit-data.populated | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| slideshow.custom-shows.initial | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| slideshow.custom-shows.validation | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| slideshow.custom-shows.populated | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| startup.slide-pane.seeded | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| startup.notes-pane.seeded | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| review.comments-pane.seeded | pass | 1280x760 logical / 1280x760 px @ 96 DPI; source 144x144 DPI | 1280x760 logical / 1280x760 px @ 96 DPI | pass | pass | pass | pass | 1100x100/1100x100; changed 16.23 %; foreground 16.23 %; mean/max 14.10/221; threshold pass | 1280x760/1280x760; changed 11.42 %; foreground 12.34 %; mean/max 8.81/255; threshold pass | [WPF](wpf/review.comments-pane.seeded.png) / [Avalonia](avalonia/review.comments-pane.seeded.png) / [target diff](diff/review.comments-pane.seeded.png) / [WPF target](wpf/targets/review.comments-pane.seeded.png) / [Avalonia target](avalonia/targets/review.comments-pane.seeded.png) / [shell diff](diff/context/review.comments-pane.seeded.png) |
| review.accessibility-pane.seeded | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| review.alt-text-pane.seeded | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| review.reading-order-pane.seeded | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| review.proofing-pane.seeded | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| accessibility.media-caption-pane.seeded | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| context.smartart-text-pane.seeded | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| animations.animation-pane.seeded | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| file.print-options.seeded | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| insert.table-picker.open | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
| design.layout-picker.open | limitation | n/a | n/a | mismatch | mismatch | mismatch | mismatch | unavailable | unavailable | n/a |
|  | Detail |  |  |  |  |  |  |  |  | WPF capture is missing. |
