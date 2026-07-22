# Floating Image Reflection Presets

## Scope

`BuildFloatingImageVisual` previously created a reflection container only for
`ReflectionPreset == 1`. Inline images already supported every nonzero preset,
including the preset-specific 4 pt gap used by preset 2.

The imported `object-format-position-size-style` fixture uses a floating,
square-wrapped image with `ReflectionPreset = 2`. Word renders the reflected
image below the primary picture; the WPF floating overlay omitted it.

## Change

Floating image overlays now use the same nonzero preset dispatch as inline
images:

- presets 1--3 use 50% reflection opacity;
- presets 4+ use 100% opacity;
- presets 2 and 5 use a 4 pt gap, preset 3 uses an 8 pt gap.

The shared `BuildReflectionContainer` remains the visual owner. No change was
made to the image payload, wrap reservation, shape effects, or non-floating
image path.

## Matched Evidence

Fresh WPF composite renders were compared with the persistent 816x1056 Word
PNG baseline for `object-format-position-size-style`:

| Region | Before mean RGB delta | After mean RGB delta |
| --- | ---: | ---: |
| Whole page | 15.7158 | 15.4868 |
| Object crop `(315,245)-(520,460)` | 54.9480 | 50.1921 |
| Reflection crop `(315,370)-(520,465)` | 50.4164 | 43.3125 |
| Body crop `(80,220)-(730,660)` | 39.0378 | 38.3479 |

The changed-pixel ratio grows from 13.2851% to 13.4847% because the previously
missing reflection introduces real ink. Mean deltas improve for the target,
the reflection, adjacent body, and whole page.

`drawing-objects-complex`, `f2-01-float-wrap`, and
`wordart-watermark-stress` were byte-identical WPF controls.

## Verification

```powershell
dotnet test freew\FreeW.App.Host.Tests\FreeW.App.Host.Tests.csproj `
  --configuration Release --no-build `
  --filter FullyQualifiedName~FloatingImageRenderTests `
  --logger "console;verbosity=minimal"
```

Result: 17/17 passed.

The consuming `FreeW.FidelityRender` Release build completed with zero warnings
and zero errors before the candidate capture.
