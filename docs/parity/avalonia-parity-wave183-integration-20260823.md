# Avalonia/WPF parity Wave 183 integration

Date: 2026-08-23

Wave 183 processed one bounded parity slice per application, bringing the
cumulative app-slice count to 549. Generated command/profile inventories still
show zero actionable Avalonia-missing commands across FreeX, FreeW, and FreeP.
The wave closes one real Linux interaction blocker and reduces two visual
residuals; it does not claim complete visual parity.

## FreeX: Linux Name Box physical parity

The Name Box dropdown now uses an in-window Avalonia overlay with the standard
ListBox for rows and selection. More importantly, the opt-in physical fixture
is reseeded only after a successful startup-file session replacement, so the
CSV opened by the Docker harness no longer discards its names, table, and
drawing objects.

On the exact final source, `name-box-dropdown-parity` passed 1/1 with an
unscaled 208x136 production crop at `(64,214)`. The complete
`name-box-dropdown` selector passed 8/8: keyboard, pointer, defined-name, table,
Chart, Picture, Shape, and TextBox postconditions all matched. The
`FreeXPhysicalEvidence` opt-in boundary and probe thresholds are unchanged.

## FreeW: About dialog geometry

FreeW now supplies WPF-measured About-dialog realization inputs through the
shared presentation contract without changing WPF or the defaults used by
other products. Across `about.initial`, `about.populated`, and
`about.validation-error`, changed pixels improved from 17.0175595% to
14.6684524%, mean channel delta from 18.4823333 to 14.4326052, p95 from
151.6666667 to 126, and pHash distance from 7 to 6. The remaining rows are
honestly classified as genuine cross-toolkit visual mismatches.

## FreeP: SmartArt follow-node materialization

The cached SmartArt path now preserves authored text-frame transforms,
materializes the semantic neutral follow-node fill, and gives WPF a native
bullet fallback only for shapes explicitly classified as cached SmartArt
follow nodes. A negative test proves ordinary right-arrow bullets retain the
generic path.

For `15-smartart-grouped-list` slide 10, WPF versus PowerPoint improved from
4.4798% to 2.5120% and Avalonia versus PowerPoint improved from 4.6698% to
2.3744%. WPF versus Avalonia remained effectively flat, moving from 1.6263%
to 1.6288%. Across all 53 tracked slides, WPF/PowerPoint now averages 1.1496%,
Avalonia/PowerPoint 1.1261%, and WPF/Avalonia 0.6286%.

## Verification

- Repository preflight passed, including all generated inventories and the
  13,594-file conflict-marker scan.
- The Release solution build passed with zero warnings and errors.
- Integrated focused lanes passed: 17 FreeX managed Name Box tests, 4 FreeX
  lifecycle/evidence guards, 5 FreeW About tests, 215 FreeP SmartArt layout
  tests, and 6 FreeP fixture-evidence tests.
- The default non-UI lane had one failure among 2,156 FreeX Avalonia tests:
  `GridCaptureTests.CaptureGridRange_WritesPngAndJsonLog_ForNewWorkbook`.
  It reproduces alone because this Windows headless environment emits an empty
  PNG, matching the pre-existing Wave 182 limitation. No product assertion or
  threshold was weakened.

## Remaining scope

Functional inventory parity remains complete for the generated inputs. The
next work should move to another physical FreeX workflow, the next classified
FreeW dialog or Word-reference mismatch, and the highest current FreeP Office
residuals, led by complex SmartArt, text, and 3-D rendering.
