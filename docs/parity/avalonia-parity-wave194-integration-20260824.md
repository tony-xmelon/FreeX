# Avalonia/WPF Parity Wave 194 Integration

Date: 2026-08-24
Tested source commit: `cacb80a5c04d3f737808e700bb58cb7ac6d22541`
Cumulative app slices: **582**, pending final integration gates

This is an acceptance-only dashboard and evidence refresh. It does not change
the tested source commit, product code, or app behavior. The dashboard keeps
functional coverage, app-owned WPF/Avalonia comparisons, and Microsoft Office
equivalence as separate claims.

## App slices

### FreeX

The physical Docker/X11 mixed-type AutoFilter workflow passes **1/1**. The
rendered checklist groups numeric `42` and text `"42"`; the workflow clears
Select All, selects `42`, and commits OK. `SUBTOTAL(103,A2:A7)` changes from
`5` to `2`; visible/readback is `42,'42,`; semantic labels are
`Number,NumericText`.

The exact saved and reopened package contract is:

`ref=A1:B7|colId=0|filters=42|blank=|hidden=4,5,6,7|A2-type=n|A2=42|A3-type=inlineStr|A3=42|A6-style=1|A6=45292|C1-formula=SUBTOTAL(103,A2:A7)|C1=2`

Focused evidence is Avalonia **8/8**, Presentation **1/1**, and Core.IO
**2/2**. The retained bundle contains **20/20 artifacts**, **10/10 reachable
provenance files**, and **2/2 validation files**. The accepted geometry is
`97,589,260,18` with click `103,598`; crop, readiness/transition checks, and
the actual click consume one authoritative geometry contract. The geometry
remediation left the physical evidence byte-equivalent.

This proves one bounded physical Linux/X11 workflow. It does not prove
complete AutoFilter or Excel visual parity.

### FreeW

The Avalonia Font dialog action-button border now uses the WPF-style `#C8C8C8`
value. The aggregate changed-pixel count improves from **32,861** to
**32,312**, a delta of **-549** and a relative improvement of **1.6712%**.
Each of the `initial`, `populated`, and `validation-error` states improves by
183 pixels. Painted bounds remain exactly `421 x 321`, and all **288** non-Font
rows remain unchanged.

This is canonical Font-dialog WPF/Avalonia evidence. The remaining native text
and control raster differences do not establish Word visual parity.

### FreeP

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

The initial independent review reported two P2 findings:

1. FreeX duplicated the mixed-type crop/readiness/transition geometry and the
   actual physical click instead of consuming one authoritative contract.
2. FreeP did not pin the complete source PPTX and initially over-attributed the
   remaining render residual to host font/raster behavior.

Both findings were remediated. FreeX now has one geometry contract plus
mutation coverage and reachable-source provenance. FreeP topology schema v3
pins the complete PPTX and states the residual as unresolved. Final independent
re-review remains pending.

## Pending integration gates

The following exact results must be recorded before Wave194 can be marked
accepted:

- Final independent re-review after both remediations.
- Full Release build of `FreeX.slnx` at the tested source commit.
- Final default non-UI test lane and authoritative project totals.
- Repository preflight at the tested source commit.

Until those results are supplied, the generated dashboard intentionally reports
Wave194 as `pending-final-integration-gates`. No visual parity claim is made by
this pending acceptance unit.

## Acceptance boundary

The git-aware acceptance boundary is re-anchored to the tested source commit
`cacb80a5c04d3f737808e700bb58cb7ac6d22541`. Only the Wave194 report, generated
dashboard artifacts, dashboard generator, dashboard behavior guard, and the
existing dashboard guard test are allowlisted for this refresh. Product code,
app tests, physical evidence, and other source drift remain rejected.
