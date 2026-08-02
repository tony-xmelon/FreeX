# Avalonia Parity Wave108 Integration

Date: 2026-08-02

## Delivered

- FreeX Error Checking now compares the same shared D6/D7 issue fixture on
  WPF and Avalonia. A fresh production Linux Docker/Xvfb capture replaced the
  stale Avalonia asset and reduced its triage score from the honest
  post-fixture `0.104142` to `0.047`.
- FreeW Accessibility Report now matches the WPF size and composition for its
  initial, populated, and validation-error states. All three moved from visual
  mismatches to passes; changed pixels fell from `7.613%` to `0.598%` and mean
  channel delta from `17.083` to `0.832`.
- FreeP adds `pictureAccentProcess` through one shared reader, authoring,
  insertion, layout, and command contract consumed by both WPF and Avalonia.

## Generated Evidence

- FreeX: 94/94 paired surfaces, zero missing or blank captures, zero logical
  dimension mismatches, and 27 raw pixel-size differences normalized by DPI.
  The highest remaining visual triage score is `0.098981` for
  `dialog.FormatCells.Border`.
- FreeW: 20 paired visual passes and 163 genuine visual mismatches, improved
  from 17 passes and 166 mismatches.
- FreeP: 622/622 shared-profile commands with zero actionable host gaps;
  dialog/pane evidence remains 28/28 pass and whole-window evidence remains
  33/33 paired with zero explicit product mismatches.

## Verification

- Focused FreeX: Services 3/3, WPF host 20/20, Avalonia compact-dialog source
  16/16.
- Focused FreeW Accessibility Report: 2/2.
- Focused FreeP SmartArt: Presentation 374/374 and WPF host/ribbon 445/445
  after the final upstream SmartArt sync.
- Linux production capture: 1/1 requested Error Checking surface, nonblank at
  720x420 with the complete action row visible.
- Repository preflight: passed after refreshing generated FreeP whole-window
  evidence provenance.
- Release solution build: passed with 0 warnings and 0 errors.
- Default non-UI lane: 35,454 passed, 0 failed, 133 not executed; 35,587 total.
- Post-sync affected suites: 1,050/1,050 passed across FreeP SmartArt and
  FreeW web-hidden/noProof model, package, Avalonia, and WPF host coverage;
  repository preflight and the full Release build then passed again.

## Remaining

- FreeX next visual slice: `dialog.FormatCells.Border`.
- FreeW retains 163 genuine local WPF/Avalonia visual mismatches and still
  needs Word-authoritative PNG baselines on a Word-capable host.
- FreeP still needs PowerPoint-authoritative picture crop/mask/effect geometry,
  broader native layout XML coverage, and richer real-deck/media/math evidence.
