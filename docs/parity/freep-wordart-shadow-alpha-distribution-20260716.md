# FreeP WordArt shadow alpha distribution

## Evidence

PowerPoint's `13-wordart.pptx` text-shadow sample uses a 5pt blur, a 5.6pt offset, and 70% opacity. FreeP approximates blur with concentric offset glyph passes because the renderer-neutral text plan does not carry a native blur filter.

The previous approximation emitted eight copies per blur ring at roughly one quarter of the requested alpha, then added another full-opacity core copy. The combined result was a large, dark halo around `Text Shadow`.

## Change

The blur approximation now distributes the requested alpha across all blur samples, including the core sample. This keeps the composite opacity bounded by the source effect while retaining a soft offset edge. Non-blurred shadows continue to use their authored alpha directly.

## Verification

Fresh 1280x720 PowerPoint comparison for `13-wordart.pptx`:

- Avalonia: `1.9289%` to `1.7055%`
- WPF: `2.0549%` to `1.8866%`

The other WordArt samples retain their existing geometry and fills.
