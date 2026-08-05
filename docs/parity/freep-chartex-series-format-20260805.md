# FreeP ChartEx series-format parity

## Scope

Native ChartEx series can carry `cx:spPr` fill and line formatting. FreeP
already modeled the equivalent `ChartSeries.Fill`, `FillColor`, and
`LineStyle`, but the ChartEx reader did not expose those children and the
writer left edits trapped in the preserved XML payload.

## Implemented

- Reader imports ChartEx series fill and line properties through the existing
  theme-aware chart shape-property parser.
- Writer updates only modeled fill and line children inside `cx:spPr`.
- Existing effect children and other unsupported `cx:spPr` content remain
  intact; a new `cx:spPr` is inserted in the ChartEx series sequence when
  needed.
- The existing ChartSeries model and slide-clone behavior remain the shared
  semantic owner; no host-specific rendering change is involved.

## Gates

- Focused series-format round-trip: **1/1**.
- Full WPF ChartTests class: **119/119**.
- WPF `FreeP.App.Host` Release build: **0 warnings / 0 errors**.
- Avalonia `FreeP.App.Avalonia` Release build: **0 warnings / 0 errors**.
- Presentation `ChartEx` filter: **5/5**.

This is function/package parity only. It makes native ChartEx series styling
editable without flattening the ChartEx family and makes no raster-fidelity
claim.
