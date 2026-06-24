# WS-G Round 3 — Chrome Typography + Metrics Parity Baseline

**Captured: 2026-06-24**
**Scope:** Title bar + status bar + general body/caption text roles in both renderers.

## Methodology

Values were read directly from source files:
- **WPF:** `src/FreeX.App.Host/MainWindow.xaml` + `src/FreeX.App.Host/Resources/MainWindowResources.xaml`
- **Avalonia:** `src/FreeX.App.Avalonia/MainWindow.cs` (code-only window)

"No explicit FontFamily" = the element inherits the system/window default font (Segoe UI on Windows, system-ui on Linux).

---

## Matched Roles (tokenized in WS-G round 3)

| Role | Token key (FreeX prefix) | WPF value | Avalonia value | Match? | WPF source | Avalonia source |
|---|---|---|---|---|---|---|
| Status bar text font size | `FreeXStatusBarTextFontSize` | 12.0 pt | 12.0 pt | MATCH | `MainWindow.xaml:1134` | `MainWindow.cs:3291` |
| Status bar text font weight | `FreeXStatusBarTextFontWeight` | Normal | Normal | MATCH | `MainWindow.xaml:1134` (no weight set) | `MainWindow.cs:3291` (no weight set) |
| Status bar text font family | `FreeXStatusBarTextFontFamily` | (inherited — empty) | (inherited — empty) | MATCH | `MainWindow.xaml:1134` (no FontFamily) | `MainWindow.cs:3291` (no FontFamily) |
| Status bar height | `FreeXStatusBarHeight` | 28 px (implicit: Padding="8,3" + FontSize=12) | 28 px | MATCH | `MainWindow.xaml:1119` | `MainWindow.cs:3388` |
| Title bar caption height | `FreeXTitleBarCaptionHeight` | 34 px | N/A — native OS title bar | See note | `MainWindow.xaml:25 WindowChrome.CaptionHeight` | n/a |

**Note on TitleBarCaptionHeight:** WPF has a custom title bar driven by `WindowChrome.CaptionHeight=34`. Avalonia uses the **native OS title bar** with no corresponding custom chrome value. The token value (34) reflects WPF only; the Avalonia applier emits the resource for key-set symmetry but the Avalonia window does not consume it. This is documented here rather than being left as a discrepancy — it is an architectural difference, not a visual difference.

---

## Parity Discrepancies (NOT tokenized — needs decision)

These roles differ between WPF and Avalonia, or exist only on one platform. They have been left with their current inline values.

| Role | WPF value | Avalonia value | Reason for discrepancy | WPF source | Avalonia source |
|---|---|---|---|---|---|
| Title bar workbook-name font size | 12 pt | — (native title bar, no custom text) | Avalonia uses native OS title bar; WPF renders a custom `TextBlock` with workbook name | `MainWindow.xaml:195` | n/a |
| Title bar workbook-name font weight | SemiBold | — | Same as above | `MainWindow.xaml:195` | n/a |
| Toolbar title text font size | — | 14 pt | Avalonia has a toolbar below the native title bar with `_titleText`; WPF has no equivalent below its custom title bar | n/a | `MainWindow.cs:2680` |
| Toolbar title text font family | — | "Arial Narrow, Aptos Narrow, Liberation Sans Narrow, …" (condensed fallback list) | Avalonia-specific toolbar font for space-efficient workbook name; WPF uses Segoe UI at 12pt in the title bar | n/a | `MainWindow.cs:2681` |
| Toolbar title text font weight | — | Normal | Avalonia-specific | n/a | `MainWindow.cs:2682` |
| Toolbar detail text font size | — | 12 pt | Avalonia-only secondary status text in toolbar | n/a | `MainWindow.cs:2688` |
| App icon "X" glyph font size | 14.5 pt | — (SVG-based icon in Avalonia) | WPF uses a TextBlock "X" glyph; Avalonia uses a rasterized/SVG icon | `MainWindow.xaml:91` | n/a |
| System button (caption button) font size | 10 pt | — | WPF SysBtnStyle FontSize (used for system button glyph metrics); Avalonia uses native window controls | `MainWindowResources.xaml:387` | n/a |
| System button width | 46 px | — | WPF only | `MainWindowResources.xaml:388` | n/a |
| Status bar zoom button/text font size | 12 pt (zoom %) / 18 pt (zoom +/-) | 12 pt (zoom %) / no explicit font size on zoom buttons | Zoom buttons in WPF use FontSize=18 SemiBold; Avalonia uses SVG glyphs | `MainWindow.xaml:1306,1349` | `MainWindow.cs:3291,3295` |

---

## Summary

- **5 roles tokenized:** StatusBarText (family/size/weight) + StatusBarHeight + TitleBarCaptionHeight (WPF-captured, Avalonia-symmetric)
- **10 roles documented as discrepancies / platform-only:** title bar workbook name, Avalonia toolbar title/detail, app icon glyph, system buttons, zoom button font

The tokenized roles are byte/pixel-identical on both renderers by construction (token values == captured current values).
