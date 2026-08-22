# Avalonia/WPF parity Wave 182 integration

Date: 2026-08-22

Wave 182 processed one bounded parity slice per application, bringing the
cumulative app-slice count to 546. Generated functional inventories still show
zero actionable Avalonia-missing commands across FreeX, FreeW, and FreeP. The
wave advances physical and visual evidence; it does not claim complete visual
parity.

## FreeX: Linux Name Box popup identity

The production Name Box popup now uses Avalonia's overlay layer on Linux,
defers list focus until the popup host is attached, and records its production
host identity and bounds. The physical parity probe now consumes that identity
instead of inferring one popup from the X11 window-count delta.

The ambiguity is resolved: the popup reports `overlay-layer` at `64,214` with
the required `208x136` bounds. The physical result remains honestly failing at
`0/1` for the parity crop and `0/8` for dropdown interaction because the overlay
content is blank in the root capture and emits no `object-selected` events.
Physical evidence is linked into the production executable only when the Docker
runner sets `FreeXPhysicalEvidence=true`; normal shipping builds exclude the
instrumentation implementation. Managed Name Box tests remain `16/16` passing
and the production build passes with zero warnings and errors. The next FreeX
slice must repair overlay rasterization/input rather than add more native-window
heuristics.

## FreeW: Font dialog geometry

The Avalonia Font dialog now uses field and action heights measured from the WPF
authority. Across `font.initial`, `font.populated`, and
`font.validation-error`, average changed pixels improved from `16.8532%` to
`11.6162%`, mean channel delta improved from `11.6888` to `10.0132`, and pHash
distance improved from `10` to `7`. The painted height increased from 298 to
313 pixels against WPF's 321 pixels.

All three rows remain genuine visual mismatches under unchanged thresholds.
The canonical aggregate therefore remains 80 passes, 141 genuine mismatches,
and 70 Avalonia extensions until a fresh complete canonical cohort is captured.

## FreeP: fixed-size Aptos body rendering

Avalonia now applies a semantic fixed-size Aptos body fallback policy to
single-column, unbulleted, no-autofit 18 pt text. Measurement and painting use a
0.945 Arial fallback scale with grayscale, non-hinted text rendering. This
replaced a rejected fixture-signature experiment that improved Office fidelity
while worsening the WPF/Avalonia pair.

For `17-bullets-autofit` slide 2, Avalonia versus PowerPoint improved from
`3.1232%` to `3.0055%` and WPF versus Avalonia improved from `3.1324%` to
`3.0952%`. WPF remains `3.0587%` versus PowerPoint, and slide 1 is unchanged.
Across all 53 tracked slides, Avalonia's Office-reference average is now
`1.1800%`; the WPF/Avalonia average is `0.6479%` with a `3.0952%` maximum.

## Remaining scope

Functional inventory parity remains complete for the generated inputs. The
next visual/physical work remains FreeX's blank/non-interactive Linux overlay,
FreeW's classified dialog and Word-reference mismatches, and FreeP's residual
native text and complex-rendering differences against WPF and PowerPoint.

## Verification

- Repository preflight passed, including generated evidence, packaging checks,
  and the 13,591-file conflict-marker scan.
- The serial Release solution build passed with zero warnings and errors.
- Integrated focused lanes passed: 16 managed Name Box tests, 4 Name Box source
  guards, 3 FreeW Font dialog tests, 1 FreeP Aptos policy test, and all 8
  deterministic integration-gate tests.
- The default non-UI lane exposed nine failures. Eight deterministic source and
  ownership contracts were corrected and rerun successfully. The remaining
  `GridCaptureTests.CaptureGridRange_WritesPngAndJsonLog_ForNewWorkbook` failure
  reproduces alone because this Windows headless environment emits an empty PNG;
  no assertion or product threshold was weakened to hide it.
