# Avalonia Parity Wave 193 Integration

Date: 2026-08-23

Wave 193 integrates one bounded evidence slice for each application. The
cumulative app-slice count is **579**, accepted after all final integration
gates passed against tested source commit
`615b53f474dfa1849ae965018d890cba4a138d42`. This report is an acceptance-only
documentation/tooling refresh; it does not alter the tested source commit.

## FreeX

Production Linux/X11 evidence closes the No Fill AutoFilter save/reopen lane
at **1/1**. The physical route selects the rendered No Fill swatch, retains
South and West, saves the empty-DXF `colorFilter` package state, reopens
through the production picker, and observes the same rows plus semantic
`A4=East`.

The focused source/evidence results are **3/3** for Avalonia and **8/8** for
Core.IO. The committed Wave193 manifest retains **18/18** artifacts and
**9/9** provenance files. Its physical transition evidence records popup-open
at **1,905** changed pixels, popup-dismissed at **1,905** changed pixels, and
restoration at **0** changed pixels, with the click acknowledged. Package tests
cover `SourcePatch` for the criterion-only, no-row-visibility-delta case and verify the saved/reopened
No Fill package semantics. Evidence is under
`docs/parity/evidence/wave193-freex-autofilter-no-fill-20260823/`.

Remaining physical color-filter coverage is mixed-type columns, multi-column
criteria, and color-filter change/clear sequencing.

## FreeW

The shared opt-in Font checkbox frame now uses a 14px indicator, a +1px
vertical offset, and the retained `#EBEBEB` / `#F6F6F6` frame colors. The
proposed 1px stroke probe was a no-op for the unchecked canonical states and
was removed.

Across `initial`, `populated`, and `validation-error`, aggregate changed
pixels improve from **34,196** to **32,861**, a reduction of **1,335** or
**3.9040%**. Each state improves by **445** pixels. WPF and Avalonia retain
exact painted bounds of **421 x 321**. Only the three Font rows changed in
the 291-row canonical comparison; all **288** non-Font rows remain unchanged,
with totals of **141 mismatch / 80 pass / 70 extension**.

The tracked provenance bundle binds the three states and six host captures to
the canonical rows, bounds, source hashes, and capture-manifest identities.
The PNG captures remain external and are not claimed as tracked artifacts.

## FreeP

No runtime rendering change is retained. The Wave193 worker run reported
**106/106** current-source renders and **159/159** comparisons, reproducing
the retained aggregate values: WPF/Office **1.0309%** average and **3.0587%**
maximum, Avalonia/Office **0.9962%** average and **2.5815%** maximum, and
WPF/Avalonia **0.6097%** average and **2.9091%** maximum.

The next executable existing-corpus residual is deck17 slide02 at
**3.0587% WPF/Office**, **2.5360% Avalonia/Office**, and **2.9091%
WPF/Avalonia**. The retained Wave193 proof is deliberately narrower than the
worker run: **53** rows, **53** Office references, and **6** target images.
Non-target full-render PNGs are not retained. The corpus and Office
references remain unchanged.

## Generated Dashboard And Guards

`tools/Generate-CrossAppParityDashboard.ps1` now generates Wave193 metadata,
the tested-source commit, the accepted 579-slice count, the empty pending
integration-gate list, and the FreeX/FreeW/FreeP Wave193 evidence summaries in both
`docs/parity/avalonia-wpf-cross-app-dashboard.json` and
`docs/parity/avalonia-wpf-cross-app-dashboard.md`.

`tools/Test-CrossAppParityDashboard.ps1` requires the Wave193 source bundles,
the accepted gate status with no pending gates, FreeX’s No Fill and manifest contracts, FreeW’s
32,861-pixel result and 0/288 non-Font stability, and FreeP’s retained versus
worker-run evidence boundary.

## Verification

The following non-build checks are part of this integration handoff:

- Dashboard generation and generated-output freshness check.
- Cross-app dashboard behavior guard.
- FreeW Font provenance/evidence consistency guard.
- FreeP Wave193 retained-evidence integrity guard.
- FreeX Wave193 source/evidence guards ran with the final tested-source
  assemblies available: the worker results remain **3/3 Avalonia** and
  **8/8 Core.IO**.
- `git diff --check`.

## Integration Gates

All final integration gates passed against tested source commit
`615b53f474dfa1849ae965018d890cba4a138d42`; no pending gates remain. The later
acceptance commit is an acceptance-only documentation/tooling refresh and does
not alter the tested source.

- Independent review found no findings after dashboard and source-guard
  remediations.
- Repository preflight passed at tested source commit
  `615b53f474dfa1849ae965018d890cba4a138d42` after conflict-marker scans of
  **288 JSON**, **306 XML-backed**, and **13,845 text files**.
- The final tested-source Release build passed with **0 warnings** and
  **0 errors** using
  `dotnet build FreeX.slnx --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`.
- The final default non-UI lane exited **0**. Key totals were Core.IO
  **5,839 passed / 56 skipped**, Avalonia **2,182 passed**, Host Logic
  **1,490 passed / 4 skipped**, FreeP Presentation **5,466 passed**, and
  FreeP Avalonia **724 passed**.
- The initial default lane exposed three source-test regressions. Remediation
  fixed all three, and focused reruns passed.

## Remaining

- FreeX: mixed-type columns, multi-column criteria, and color-filter
  change/clear sequencing.
- FreeW: the remaining native Font glyph/raster tail and other classified
  Word/dialog visual residuals.
- FreeP: a genuinely new Office-authored topology is required before another
  general projection correction is attempted for the Surface3D residual.
