# Avalonia/WPF Parity Wave 194 Integration

Date: 2026-08-25
Tested source commit: `8624e6d1f4bce133a3685d99f366e668491ea33f`
Cumulative app slices: **582** (**194 per app**)
Unprocessed slices: **0**

This is an acceptance-only dashboard and evidence refresh. It does not change
the tested source commit, product code, or app behavior. Functional/source
parity evidence, app-owned WPF/Avalonia comparison evidence, and Microsoft
Office reference evidence are separate claims. This report does **not** claim
100% visual parity.

## App slices

### FreeX

The generated functional matrix records **575** commands, **569** parity
rows, **0** Avalonia-missing rows, and **0** real classified behavior gaps.
Dialog route coverage is **57/57** on both hosts, with **94/94** paired
WPF/Avalonia manifest surfaces and **0** unresolved high-delta review
candidates in the generated FreeX dialog triage queue.

The retained Excel comparison evidence contains **36** foreground ribbon
references for each of Excel, WPF, and Avalonia, including Draw, with **27**
fixed-viewport triage rows. The mean RGB deltas versus Excel are **13.9366%**
for WPF and **15.6391%** for Avalonia. These are triage measurements, not
visual-parity acceptance thresholds.

The physical Docker/X11 mixed-type AutoFilter workflow passes **1/1**. The
rendered checklist groups numeric `42` and text `"42"`; the workflow clears
Select All, selects `42`, and commits OK. `SUBTOTAL(103,A2:A7)` changes from
`5` to `2`; visible/readback is `42,'42,`; semantic labels are
`Number,NumericText`.

The exact saved and reopened package contract is:

`ref=A1:B7|colId=0|filters=42|blank=|hidden=4,5,6,7|A2-type=n|A2=42|A3-type=inlineStr|A3=42|A6-style=1|A6=45292|C1-formula=SUBTOTAL(103,A2:A7)|C1=2`

Focused evidence is Avalonia **9/9**, Presentation **1/1**, and Core.IO
**8/8** (Wave194 plus five foreground-capture guards). The retained bundle contains **20/20 artifacts**, **10/10 reachable
provenance files**, and **2/2 validation files**. The accepted geometry is
`97,589,260,18` with click `103,598`; crop, readiness/transition checks, and
the actual click consume one authoritative geometry contract. The geometry
remediation left the physical evidence byte-equivalent.

This proves one bounded physical Linux/X11 workflow. It does not prove
complete AutoFilter or Excel visual parity.

### FreeW

The current generated inventory records **952** commands, **731** both-profile
rows, **216** profile-shape-only rows, and **0** actionable gaps. The current
dialog comparison manifest contains **291 rows**:

| Classification | Count |
|---|---:|
| Pass | 80 |
| Genuine visual mismatch | 141 |
| Avalonia extension | 70 |

The **221** paired rows therefore contain **80** local comparison passes and
**141** genuine visual mismatches. The **70** Avalonia extensions are reported
separately because they have no WPF authority row. The current shell evidence
contains **40** paired static captures, **32** paired contextual captures, and
**36** native Word ribbon references. This is functional/source coverage plus
visual evidence; it is not a Word visual-parity claim.

The Avalonia Font dialog action-button border now uses the WPF-style `#C8C8C8`
value. The aggregate changed-pixel count improves from **32,861** to
**32,312**, a delta of **-549** and a relative improvement of **1.6712%**.
Each of the `initial`, `populated`, and `validation-error` states improves by
183 pixels. Painted bounds remain exactly `421 x 321`, and all **288** non-Font
rows remain unchanged.

This is canonical Font-dialog WPF/Avalonia evidence. The remaining native text
and control raster differences do not establish Word visual parity.

### FreeP

The generated command inventory records **708/708** both-profile commands and
**0** actionable gaps. Current app-owned visual evidence records **33/33**
whole-window scenarios, **28/28** dialog scenarios, **28/28** native
PowerPoint chrome references, **32** responsive WPF/Avalonia pairs (**64**
captures), and **61/61** paired local WPF/Avalonia comparisons.

No runtime change is made. Wave194 records schema v3 topology evidence for
deck17 slide02 and pins the complete source corpus file
`tools/FreeP.RenderCompare/corpus/17-bullets-autofit.pptx` to SHA-256
`f4fc0c9e3d048cac3e0c7fe3d929029238448ff05281be542df105a46c6c88ea` over the
entire raw file.

The title uses `spAutoFit`, effective theme font Aptos Display at 28 pt. The
body uses `noAutofit`, effective theme font Aptos at 18 pt, and eight
paragraphs. The retained residual remains unresolved; the topology evidence
rules out only the investigated structural, autofit, and theme-inheritance
hypotheses. It does not attribute the residual to host fonts or rasterization,
and it does not claim PowerPoint visual parity.

## Review history

The retained review remediations remain valid: FreeX uses one authoritative
mixed-type geometry contract with mutation coverage and reachable-source
provenance. FreeP topology schema v3 pins the complete PPTX and describes its
remaining rendering residual as unresolved. The prior final independent review
is superseded by the later FreeP Surface3D hardening. The supplied current
FreeP Surface3D static sign-off is clean, but a fresh independent final
cross-app acceptance review of the current tested source is still pending.

The current integration branch is anchored to
`8624e6d1f4bce133a3685d99f366e668491ea33f`. This refresh does not expand the
acceptance allowlist or reinterpret visual mismatch rows as functional gaps.

## Integration gates

All supplied final integration gates passed at tested source commit
`8624e6d1f4bce133a3685d99f366e668491ea33f`.

- Repository preflight: passed with exit code 0 using
  `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1`;
  **294 JSON**, **309 XML-backed**, **125 PowerShell scripts**, **10 test
  gates/48 assigned projects**, **13,922 conflict-marker files**, and all
  generated docs/evidence current.
- Full Release build: `dotnet build FreeX.slnx --configuration Release -m:1`
  passed with **0 warnings and 0 errors** in **00:06:14.37**.
- Final default non-UI lane: **31 unique TRXs** and matching console
  aggregation, with **43,485 passed**, **134 intentional skips**, **0 failed**,
  **43,619 total**.
- Focused current FreeP evidence: ChartRenderPlanner **264/264**, FreeP
  Presentation **5,496/5,496**, host **2,418/2,418**, Avalonia **724/724**,
  ribbon definitions **34/34**, responsive evidence **64/64**, localization
  focused **1/1**, resources **14/14**, and Hide Slide assertions **2/2**.

This documentation refresh records the supplied gate results and does not rerun
the full build or default lane.

Wave194 is accepted at 582 cumulative app slices, with zero unprocessed slices.
Functional/source parity evidence is complete for the generated command/profile
and focused-gate surfaces, while visual mismatch evidence remains explicitly
open as described above. No 100% visual parity claim is made.

## Acceptance boundary

The git-aware acceptance boundary is re-anchored to the tested source commit
`8624e6d1f4bce133a3685d99f366e668491ea33f`. Only the Wave194 report, generated
dashboard artifacts, dashboard generator, dashboard behavior guard, and the
existing dashboard guard test are allowlisted for this refresh. Product code,
app tests, physical evidence, and other source drift remain rejected.
