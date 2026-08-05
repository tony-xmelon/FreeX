# FreeP ChartEx legend parity

## Scope

Native ChartEx legends use `cx:legend/@pos` and `@overlay` attributes. FreeP
already exposed legend position and overlay in the shared `ChartShape` model,
but ChartEx import ignored the native element and preserved-payload edits could
not update it.

## Implemented

- Reader maps the native `l`, `t`, `b`, and `r` position tokens plus the optional
  overlay toggle into the existing shared chart model.
- Writer updates those modeled attributes on preserved ChartEx payloads while
  retaining unrelated attributes such as `align`.
- Newly generated ChartEx documents emit the requested legend element.
- Classic chart behavior is unchanged; this is a ChartEx package/editing slice,
  not a renderer calibration.

## Gates

- Focused native legend round-trip: **1/1**.
- Full WPF ChartTests class: **120/120**.
- ChartEx presentation filter: **5/5**.
- WPF `FreeP.App.Host` Release build: **0 warnings / 0 errors**.
- Avalonia `FreeP.App.Avalonia` Release build: **0 warnings / 0 errors**.
