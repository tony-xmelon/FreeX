# Native VML `fitshape` Retention

## Scope

FreeW now retains the visible `v:textpath/@fitshape` token for imported VML
text watermarks. An explicit `t` or `f` survives import and save; a newly
authored watermark continues to emit Word's canonical `fitshape="t"`.

This keeps the serialized text-path contract available to a later renderer
dispatch instead of reducing every imported VML watermark to generic text,
font, opacity, rotation, and rectangle values.

## Verification

- `WatermarkOptionsRoundTripTests` passed 22/22. The focused theory covers
  both `fitshape="t"` and `fitshape="false"`, asserts the recovered model
  value, then verifies the rewritten VML token is canonicalized to `t` or `f`.
- Release `FreeW.FidelityRender` built with 0 warnings and 0 errors after the
  consuming dependency chain was refreshed.
- Fresh 816 by 1056 composite controls for canonical `fitshape="t"` stayed
  byte-identical to their current WPF baselines:
  `f2-border-watermark` SHA-256 `A95E8A58...CB182B`, and
  `wordart-watermark-stress` SHA-256 `70AC104E...301A9`.

## Visual Follow-up

The existing uniform WPF `FormattedText` approximation is not an implementation
of VML `fitshape`. Two fresh Word-matched probes were rejected: removing only
the historical half-scale worsened the isolated `f2-border-watermark` whole
page from 3.9108% to 3.9934%, while removing the 130-DIP cap as well worsened
it to 4.3578%. The next raster slice must consume the retained VML text-path
semantics with a shape-aware geometry model, not tune a global font scale or
offset.
