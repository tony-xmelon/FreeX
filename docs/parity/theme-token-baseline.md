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
| Status bar height | `FreeXStatusBarHeight` | content-auto (Padding="8,3", no explicit Height) | 28 px (explicit) | SOFT-DIFF | `MainWindow.xaml:1119` | `MainWindow.cs:3388` |
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

- **Tokenized + WIRED (byte/pixel-identical, default unchanged):** StatusBarText font size/weight/family (WPF + Avalonia, both 12pt/Normal/inherited); StatusBarHeight on **Avalonia only** (it had an explicit 28px → token 28px, identical).
- **Token defined but deliberately NOT wired on WPF:** `FreeXStatusBarHeight` — WPF's status bar is **content-auto** (no explicit Height; `Padding="8,3"`). Forcing an explicit 28px would change auto→fixed (a potential DPI/content pixel shift), so the WPF status bar is left auto-sized. The 28px is Avalonia's actual value; whether WPF's content-auto height equals 28px in all DPI/content cases is an open parity question (left for a real rendered-capture comparison, not assumed). `FreeXTitleBarCaptionHeight` (34) reflects WPF's `WindowChrome.CaptionHeight`; Avalonia uses the native OS title bar (architectural difference, not consumed).
- **10 roles documented as discrepancies / platform-only:** title bar workbook name, Avalonia toolbar title/detail, app icon glyph, system buttons, zoom button font.

Tokenized+wired roles are byte/pixel-identical on both renderers by construction (token values == captured current values). Heights were intentionally NOT force-applied where the platform was auto-sizing, to avoid masking or breaking the real cross-platform parity this baseline exists to protect.

---

## FreeX-Avalonia chrome divergences (Win/Linux fidelity gaps)

**Captured: 2026-06-25 — WS-G round 11**

This section documents Avalonia chrome color literals that do NOT byte-match the corresponding WPF/BrandThemes.FreeX token value. These are candidates for a future convergence decision; they were NOT changed in this round.

| Role | WPF / BrandThemes.FreeX token | Avalonia literal | Delta | Site |
|---|---|---|---|---|
| Window background | *(no direct role — closest: ChromeSurface #F7F8F8, SheetSurface #F3F3F3)* | `#F6F7F9` (246,247,249) | Neither role matches | `src/FreeX.App.Avalonia/MainWindow.cs:344` `WindowBackground` |
| Toolbar border | `Border` #DADCE0 (218,220,224) | `#DADES4` (218,222,228) | G: 220→222, B: 224→228 | `src/FreeX.App.Avalonia/MainWindow.cs:348` `ToolbarBorder` |
| Primary ink (title text, formula bar, glyph rules) | `Text` #1F1F1F (31,31,31) | `#191F28` (25,31,40) | R: 31→25, B: 31→40 | `src/FreeX.App.Avalonia/MainWindow.cs:387` `PrimaryInk` |
| Secondary ink (detail text) | `MutedText` #5F6368 (95,99,104) | `#5E6774` (94,103,116) | R: 95→94, G: 99→103, B: 104→116 | `src/FreeX.App.Avalonia/MainWindow.cs:388` `SecondaryInk` |
| Dialog control border | *(no matching token role — between Border #DADCE0 and BorderStrong #C8CCD0)* | `#ABABAB` (171,171,171) | Much lighter than any border token | `src/FreeX.App.Avalonia/DialogControlStyles.cs:44` `BorderBrush` |
| Dialog selection brush | *(derived: AccentSoft @ alpha 0x40 — no standalone token role)* | `AccentSoft`@40% opacity (0x40,0x0F,0x6D,0x8C) | Derived, not a distinct role | `src/FreeX.App.Avalonia/DialogControlStyles.cs:49` `SelectionBrush` |

### Notes

- **WindowBackground** — the Avalonia window background (`#F6F7F9`) sits between the `ChromeSurface` (#F7F8F8) and `SheetSurface` (#F3F3F3) tokens and matches neither. It colors the OS-level window background behind all content (visible only when the window is partially transparent or during resize). On WPF the equivalent is the native window chrome background; no direct token role exists. Convergence decision deferred.

- **ToolbarBorder** — the Avalonia formula-bar bottom border uses (218,222,228); the WPF `Border` token is (218,220,224). A 2-point difference in G and B channels — likely the source artist used a slightly different gray for the horizontal rule. Small visual difference; converging would require a new token role or overriding the `Border` token value.

- **PrimaryInk / SecondaryInk** — the Avalonia toolbar/chrome uses a warmer dark navy (#191F28, #5E6774) distinct from the WPF text neutrals (#1F1F1F, #5F6368). These serve the Avalonia-only toolbar (title + detail text below the native OS title bar) which has no WPF equivalent; the colors were chosen for contrast on the ChromeSurface background, not to match WPF text ink. Convergence would require confirming the same contrast ratios hold.

- **DialogControlBorderBrush** — the dialog checkbox/radio/listbox border (#ABABAB) is a mid-gray chosen for compact WPF-like dialog styling. The FreeX `Border` (#DADCE0) and `BorderStrong` (#C8CCD0) tokens are both lighter. This is a dialog-specific design choice, not a shared chrome surface.

- **SelectionBrush** — derived from `Accent` at 25% opacity. A dedicated token role (e.g. `AccentGhost`) would be needed to tokenize this; out of scope for this round.
