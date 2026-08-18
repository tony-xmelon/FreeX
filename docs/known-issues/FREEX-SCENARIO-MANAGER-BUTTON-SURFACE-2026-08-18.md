# ScenarioManager capture expects a #DDDDDD button surface that no longer exists

`ScenarioManager_CapturesCanonicalFrameWithWpfButtonSurfaceAndNoBottomClip` asserts
`CountExactColor(image, 221, 221, 221) > 600`. It finds 0.

## Status

**RESOLVED** in `d9b99390ef`, with the owner's agreement that white buttons are correct.
The colour check is replaced by one asserting the action row renders visible buttons rather
than blending into the background. A second assertion in the same test wanted #C6D7E8 for
the group border; `645bd68d04` had deliberately moved that onto
`CompactDialogVisualTokens.BorderHex` (#C8C8C8), so it now tracks the token. Batch5 is 6/6.

## Why it surfaced now

The test was an async-void `Dispatch` lambda and silently swallowed its own assertions
until `87a7f11138`. It is a latent gap that fix unmasked, not a new regression.

## What is actually true

- `#DDDDDD` is **not** a WPF colour. Nothing under `shared/Free.Shared.Shell.Wpf/` or
  `src/FreeX.App.Host/` defines it, so the test name ("WpfButtonSurface") is misleading
  about what it measures.
- `#DDDDDD` is Avalonia's default-theme button fill. The assertion originally passed
  because the ScenarioManager dialog's buttons were *unstyled*.
- `AvaloniaCompactDialogChrome.ApplyButton` resolves
  `style.ButtonBackgroundBrush ?? ThemeWhiteBrush()`. No call site anywhere sets
  `ButtonBackgroundBrush`, so every chromed dialog button paints white.
- Pre-existing, not caused by `645bd68d04` — the default was `Brushes.White` before that
  commit too. Applying the shared chrome to this dialog is what removed the grey.

So the test encodes "buttons have a visible neutral fill distinct from the dialog
background", and the dedup to shared chrome made them white-on-white.

## The decision required

Either the compact chrome should give buttons a neutral resting fill (a change visible
across *every* dialog in all three apps), or the assertion should be rebased onto whatever
WPF genuinely renders. Determining the latter needs a WPF ground-truth render.

Do not simply set `ButtonBackgroundBrush = #DDDDDD` to make the test pass: that colour has
no WPF authority behind it and would restyle the whole suite on the strength of one
assertion.

## Killed leads

- Not a `645bd68d04` regression (checked the diff; default was already white).
- Not the dialog-inspection auto-close bug fixed in `f3ac016069` (this is a render pass,
  `render: true`, which never had the auto-close suppressed).
