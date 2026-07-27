# FreeX Options Language Wave 27

Date: 2026-07-27

This slice is limited to `dialog.Options.Language` and uses current-source WPF
and Avalonia captures at the shared `744x521` logical client frame.

## Diagnosis and fix

Avalonia previously rendered a disabled two-item placeholder combo and used the
generic Options panel spacing. WPF renders an enabled selector populated from
the shared `AppLanguageCatalog`, with a 230 px label column and 240 px field.

The bounded fix:

- wires Avalonia to the shared language catalog and normalized persisted culture;
- carries the selected culture through `OptionsDialogPlanner` into `AppOptions`;
- aligns the Language header, field width, zero-gap label row, and description
  margins to the WPF metrics;
- forces the fixed Options window to manual sizing so the catalog does not make
  the headless Language capture grow to `744x777`.

## Evidence

| Measure | Before | After |
| --- | ---: | ---: |
| Generated triage score | 0.103708 | 0.021 |
| Direct changed-pixel comparison | historical outlier | 1.63% |
| WPF logical frame | 744x521 | 744x521 |
| Avalonia logical frame | 744x521 | 744x521 |

Fresh WPF evidence came from the focused `dialog.Options.Language` parity
capture. Fresh Avalonia evidence came from the self-contained Linux publish in
the local `freex-linux-interactive:ubuntu24.04` Docker image under Xvfb.

## Verification

- `OptionsDialogPlannerTests`: 35/35 passed.
- Avalonia `OptionsDialogGeneralParitySourceTests`: 3/3 passed.
- WPF `OptionsDialogSourceTests`: 43/43 passed.
- Dialog visual evidence generator: passed with 94 paired captured surfaces,
  zero nonblank failures, and zero paired dimension mismatches.

## Residuals

The remaining 0.021 triage score is primarily Avalonia/Linux text
rasterization, font anti-aliasing, and native combo-box arrow/control chrome.
The Language page content, selection state, persistence path, and logical frame
are now aligned; other Options pages are intentionally outside this slice.
