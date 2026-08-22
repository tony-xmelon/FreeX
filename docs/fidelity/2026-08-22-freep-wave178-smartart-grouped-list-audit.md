# FreeP Wave178 SmartArt grouped-list audit

Date: 2026-08-22
Branch: `codex/parity-wave178-20260822`
Base: `8a10ce470f34c0b2acc85a24bb64bc018208100b`

## Result

No renderer production change was accepted. The bounded candidates were not
evidence-safe across both renderers and sibling SmartArt controls:

- Slide 09 is `IncreasingCircleProcess`, not a grouped-list layout. Its richer
  12-shape PowerPoint cache is outside the bounded live grammar, so the reader
  keeps the cache authoritative. WPF is geometrically aligned with the Office
  PNG; the WPF/Avalonia heatmap is concentrated on glyph width and
  antialiasing.
- Slide 10 is `vList6`, which is intentionally outside the live-layout
  allowlist. The reader retains the four-shape Office `dsp:drawing` cache,
  including four authored bullet paragraphs. Its WPF/Avalonia pair residual
  is renderer text behavior, while its larger Office residual includes the
  cached SmartArt fill/style. Promoting it to a new live layout would replace
  Office-authoritative geometry and styling without a bounded semantic model.
- A renderer-wide WPF bullet fallback or Avalonia text-width adjustment could
  alter unrelated bullet/text corpus slides. No isolated correction was
  demonstrated that improves both target slides without risking sibling
  fidelity, so production sources remain unchanged.

## Fresh 1280x720 evidence

Outputs were rendered from the committed deck with
`dotnet run --project tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj -c Release --no-build -- --avalonia-compare ...`.
PowerPoint COM is unavailable on this machine, so the committed Office PNGs
were compared directly with the fresh WPF/Avalonia PNGs using the RenderCompare
`--diff` path.

| Slide | Fresh WPF vs Office | Fresh Avalonia vs Office | Fresh WPF vs Avalonia |
| --- | ---: | ---: | ---: |
| 09 | 1.6516% | 1.6879% | 1.6609% |
| 10 | 4.4798% | 4.6503% | 1.6260% |

For context, the ten-slide fresh WPF/Avalonia pair average was 0.8896%.
The committed Office PNGs are unchanged. Since no production candidate was
accepted, before/after production metrics are identical to the fresh rows
above.

## Regression coverage

`SmartArtFixtureEvidenceTests.GroupedListOutlierSlidesKeepTheirAuthoritativeSmartArtRoutes`
locks the actual reader model for slides 09 and 10: the cached-authoritative
`IncreasingCircleProcess` route, the unsupported cached `vList6` route, and
the four authored cached bullet paragraphs.

## Residuals and environment

- Slide 09 residual: shared WPF/Avalonia text rasterization/measurement floor.
- Slide 10 residual: WPF cached-bullet materialization difference plus Office
  cached SmartArt style/fill mismatch; the shared live layout route is not
  authoritative for this `vList6` input.
- PowerPoint reference refresh could not run because
  `PowerPoint.Application` is not registered. The committed Office PNGs were
  used as the reference authority.
