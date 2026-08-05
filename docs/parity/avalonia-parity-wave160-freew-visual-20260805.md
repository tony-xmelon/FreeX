# Wave160 FreeW About visual parity

Date: 2026-08-05

## Gap proved

Fresh paired WPF/Avalonia harness captures selected the `about` route as the highest-impact
actionable residual after Wave159. The WPF authority centers the short About document inside
the read-only viewport. Avalonia centered the outer `TextBox`, but its template-owned
`ScrollViewer` still started the document at the top. The fresh pre-fix `about.initial` pair
measured 46,577 changed pixels (13.8622%) and 18.4056 mean absolute channel delta at 560x600.

## Implemented

The shared Avalonia About realization now installs a local descendant style that sets the
template `ScrollViewer.VerticalContentAlignment` to `Center`. The existing Legal Notices
top-aligned document contract and shared metrics remain unchanged. The focused FreeW test
pins the WPF-derived About geometry/content and the new template style contract.

## Evidence

- Full paired harness run: WPF **190/190** captured; Avalonia **288/288** captured; all
  content gates passed.
- Mechanical canonical refresh used `--baseline docs/parity/freew-dialog-harness/freew_dialog_visual_comparison.json`
  and `--refresh-route about`.
- Refreshed About initial/populated/validation rows measure **38,338 changed pixels
  (11.4101%)** and **14.2869 mean absolute channel delta**, a reduction from the fresh
  pre-fix pair above. They remain `genuine-visual-mismatch` for native framework
  text/control rasterization; thresholds and classifications were not changed.

## Verification

- FreeW Avalonia About authority test: **1 passed**.
- FreeW Avalonia test-project Release build: **0 warnings, 0 errors**.
- Harness Release builds: **0 warnings, 0 errors**.
- `Test-FreeWDialogVisualEvidence.ps1`: **295 rows; 159 genuine visual mismatches;
  24 passes; 105 Avalonia extensions; 7 not-applicable**.
- Cross-app dashboard schema/evidence guards: passed.
- Harness inventory `--check`: passed.
- Harness comparison `--check`: passed.
- `git diff --check`: passed.

No PNGs, metrics, thresholds, or classifications were hand-edited.
