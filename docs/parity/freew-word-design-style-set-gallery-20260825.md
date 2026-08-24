# FreeW Word Design style-set gallery — 2026-08-25

## Scope

This visual-parity slice covers the WPF and Avalonia FreeW Design tabs at the
1280px Word reference width. Ink/Draw behavior and map-chart fidelity remain explicitly
out of scope for the wider parity effort.

## Reference and correction

`docs/parity/freew-word-chrome-2026-08-16/word_1280_design.png` shows a small
Themes chooser followed by the wide Document Formatting style-set gallery.
FreeW previously used its four-theme catalog as the visible gallery and left
all ten backed style sets in a compact menu, making the Design ribbon sparse.

`ThemeGallery.BuildDocumentFormatting` now provides:

- a compact Themes menu;
- eight visible catalog-backed style-set previews (Office through Shaded);
- a More Style Sets menu for the complete ten-item catalog; and
- the existing Colors, Fonts, Paragraph Spacing, and Effects menus.

The implementation preserves the existing hover-preview, cancel-preview, and
apply callbacks; no new model or external dependency is required.

Avalonia now uses the same hierarchy: a compact Themes chooser, eight direct
style-set previews, a More Style Sets menu, and the existing Colors, Fonts,
Paragraph Spacing, and Effects catalogs. Its headless capture is
`artifacts/ux-parity-freew-avalonia-design-20260825/revised/shell-1280x900-design.png`.

## Evidence

The captured result is
`artifacts/ux-parity-freew-ribbons-20260825/design-style-sets-eight/ribbon-3-Design.png`,
produced with:

```powershell
dotnet run --project freew/tools/FreeW.RibbonShot/FreeW.RibbonShot.csproj -c Release --no-build -- artifacts/ux-parity-freew-ribbons-20260825/design-style-sets-eight 3 1280 900
```

Focused verification:

```powershell
dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~ThemeGalleryTests" --logger "trx;LogFileName=theme-gallery-focused.trx"
```

Result: 2 passed, 0 failed.
