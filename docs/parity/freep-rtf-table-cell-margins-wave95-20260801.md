# FreeP RTF Table Cell Margins, Wave 95

FreeP now keeps authored RTF cell padding through nested-table parsing and the rich clipboard codec into the Avalonia inline-table renderer. `\\clpadl`, `\\clpadr`, `\\clpadt`, and `\\clpadb` continue to map to the shared `TableCell` inset model; Avalonia now applies all four sides and honors the existing top/middle/bottom cell anchor when drawing inline tables. WPF already consumed these shared values through its inline table editor.

Focused coverage verifies nested inner-cell margins before and after clipboard serialization, plus Avalonia text-area and vertical-anchor placement. Remaining inline-table differences include richer nested-table visual recursion, merged-cell geometry, and full per-run formatting in the Avalonia editing surface.
