# Avalonia/WPF Parity Wave 194 Integration

Date: 2026-08-24
Tested source commit: `3d60b7b421b388ccfa5c9c18dc4e25642b7a14c6`
Cumulative app slices: **582**, accepted after final integration gates

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

Focused evidence is Avalonia **9/9**, Presentation **1/1**, and Core.IO
**8/8** (Wave194 plus five foreground-capture guards). The retained bundle contains **20/20 artifacts**, **10/10 reachable
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

Both findings were remediated at the prior tested source. FreeX now has one
geometry contract plus mutation coverage and reachable-source provenance. FreeP
topology schema v3 pins the complete PPTX and states the residual as unresolved.
The tested source then advanced because the first full default lane exposed
three over-broad color-geometry source-guard failures.

The initial default lane exited **1** solely because the Wave191/192/193
color-geometry guard was bounded through a later selector and counted
`mixed_type_target_click_x_offset`. At that pre-remediation source, FreeX
Avalonia reported **2,188 passed, 3 failed, 2,191 total**.

Remediation commit `f2aab993242fa6a6cc49d67c4b7770c23ce4c067` structurally scopes
the old guard to `probe_autofilter_color_persistence_physical` and adds
isolation and inside-function mutation tests. Worker verification passed:
failing classes **11/11**, full color lane **17/17**, Wave194 **9/9**, full
Avalonia project **2,193/2,193**, and focused project build **0/0**. There was
no runtime harness or evidence change.

The prior final no-findings review is superseded by this source advancement.
Final independent review found no findings. The reviewer verified that f2a
structurally scopes the color function before the mixed-type function, accepts
the later decoy, rejects the internal assignment, verifies Wave191-193 retained
hashes **11/11, 11/11, 18/18**, verifies Wave194 **20 evidence plus 12
provenance/validation**, and found FreeP and FreeW clean.

The accepted Wave194 histories were reintegrated with current origin/main's six
foreground-capture commits in merge `3d60b7b421b388ccfa5c9c18dc4e25642b7a14c6`.
The merge contained zero overlapping paths between those inputs. The initial
repository preflight reached the generated/dashboard guards and failed only
because the prior tested-source anchor treated these incoming paths as outside
the acceptance allowlist: `docs/testing/freex-excel-ux-parity-suite.md`,
`tests/FreeX.Core.IO.Tests/ToolHarnessDedupSourceTests.cs`, and
`tools/FreeX.ForegroundCapture/Program.cs`. This was remediated by anchoring
tested source at `3d60b7b421b388ccfa5c9c18dc4e25642b7a14c6`, not by expanding
the allowlist.

## Integration gates

All final integration gates passed at the tested source commit.

- Final independent review: passed with no findings; all source-guard and
  evidence checks above were verified.
- Reintegration: merge `3d60b7b421b388ccfa5c9c18dc4e25642b7a14c6` contained
  current origin/main's six foreground-capture commits with the accepted
  Wave194 histories and had zero overlapping paths between those inputs.
- Focused tests at the tested source: FreeX Avalonia Wave194 **9/9**; FreeX
  Presentation Wave194 **1/1**; FreeX Core.IO Wave194 plus five
  foreground-capture guards **8/8**; FreeP Presentation Wave194 **2/2**.
- Initial repository preflight: reached the generated/dashboard guards and
  failed only because the prior tested-source anchor treated the three incoming
  foreground paths listed above as outside the acceptance allowlist; the fix
  re-anchored tested source to `3d60b7b421b388ccfa5c9c18dc4e25642b7a14c6`
  without expanding the allowlist.
- Full Release build: passed at tested source commit
  `3d60b7b421b388ccfa5c9c18dc4e25642b7a14c6` with 0 warnings and 0 errors,
  elapsed `00:13:08.13`, using `dotnet build FreeX.slnx --configuration Release
  --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false
  /nr:false -m:1`.
- Final default non-UI lane at tested source commit
  `3d60b7b421b388ccfa5c9c18dc4e25642b7a14c6`: exited 0 with **43,432 passed,
  134 skipped/not-run, 0 failed, 43,566 total**. There were 25 unique TRX files plus 31 additional
  passed captures overwritten into the shared capture TRX path across seven
  capture assemblies. Key totals: FreeP Avalonia 724/0; FreeP Host 2,409/0;
  FreeP Presentation 5,468/0; FreeX Avalonia 2,193/0; Host Logic 1,490 passed/4
  skipped; Presentation 5,465/1; Core.IO 5,846/56; Core Model 6,317/41;
  Formula 5,199/7; Calc 1,982/24; Integration 661/1.

- Repository preflight: passed at tested source commit
  `3d60b7b421b388ccfa5c9c18dc4e25642b7a14c6` with exit 0 using
  `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-RepositoryPreflight.ps1`.
  It validated **292 JSON**, **306 XML-backed**, and **13,862 text** files for
  conflict markers; **117 PowerShell scripts**, **10 workflows**, **160 project
  files**, **124 solution entries**, **32 default-test entries**, **51 FreeW
  entries**, and **42 FreeP entries**. Linux packaging passed, and generated
  docs/dashboard plus FreeW/FreeP inventories/evidence were current.

Wave194 is now accepted at 582 cumulative app slices. No visual parity claim is
made by this functional/evidence acceptance record.

## Acceptance boundary

The git-aware acceptance boundary is re-anchored to the tested source commit
`3d60b7b421b388ccfa5c9c18dc4e25642b7a14c6`. Only the Wave194 report, generated
dashboard artifacts, dashboard generator, dashboard behavior guard, and the
existing dashboard guard test are allowlisted for this refresh. Product code,
app tests, physical evidence, and other source drift remain rejected.
