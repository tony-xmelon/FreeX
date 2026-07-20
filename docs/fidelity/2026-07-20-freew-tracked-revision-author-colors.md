# FreeW tracked revision author colors

## Scope

`f2-tracked-changes.docx` is a two-page tracked-change fixture. Word assigns its first three
revision authors distinct display colors: Alice `#0070C0`, Bob `#8064A2`, and Carol `#70AD47`.
FreeW previously rendered every insertion and deletion in a single maroon color.

## Change

`ReviewRevisionColorPlanner` assigns colors by first revision appearance in document reading order.
Both WPF and Avalonia consume the shared plan for revision foregrounds and their underline/strike
decorations. WPF records the applied display tint in the run marker so committing an edited document
removes it instead of serializing it as authored run formatting.

## Matched Word evidence

Persistent Word COM baseline and WPF composite candidate were both `816x1056`.

| Page | Before | After | Result |
| --- | ---: | ---: | --- |
| `f2-tracked-changes` page 1 | 2.4359% | 2.3649% | -0.0710 pp |
| `f2-tracked-changes` page 2 | 1.2799% | 1.2799% | byte-stable control |

The page-1 candidate changed only revision chrome relative to the previous WPF image
(`0.1567%` mean-channel difference). Page 2 SHA-256 remained
`E0B3E655C951300D75BECDE54454F5645ADB5B9E5306DACF1B816DF7176255FE`.

## Verification

- `ReviewRevisionColorPlannerTests`: 2/2 passed.
- `TrackingDisplayControlTests.AllMarkup_uses_author_palette_without_serializing_display_colours`: 1/1 passed.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- `FreeW.App.Avalonia` Release build: 0 warnings, 0 errors.
