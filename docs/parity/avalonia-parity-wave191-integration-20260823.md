# Avalonia Parity Wave 191 Integration

Date: 2026-08-23

Wave 191 processes one bounded slice per application and brings the cumulative
app-slice count to **573**. Generated command inventories still report zero
actionable Avalonia-missing commands across FreeX, FreeW, and FreeP. The wave
closes a physical Linux fill-color workflow, reduces a three-state FreeW dialog
residual, and corrects a FreeP semantic gate so its measured improvement is
active in current source.

## FreeX

The production Linux X11 fill-color AutoFilter lane passes **1/1** through the
rendered `#00B050` swatch, save, the identity-checked production Open picker,
and reopen. It retains rendered `North,East,`, independently reads semantic
`A4=East`, and saves `cellColor=1`, `dxfId=0`, and fill `FF00B050`.

`XlsxAutoFilterXmlCodec` now writes the fill/font selector explicitly as `1` or
`0`, while preserving native raw attributes when supplied. Four rendered PNGs,
the fixture and saved package, diagnostics, exact source hashes, and the Docker
image digest are committed under
`docs/parity/evidence/wave191-freex-autofilter-color-20260823/`. The original
provisional run was rejected because it reused a base image; the accepted run
rebuilt from clean committed source. The rendered-pixel gate proves that the
sample changed from `#FFFFFF` to `#00B050` before the bounded click. All 17
manifest entries declare either canonical-LF text hashing or strict raw binary
hashing and match worktree, committed Git blob, and Windows-checkout variants.

## FreeW

The Avalonia Font dialog now applies the WPF-authority selected-combo gradient,
neutral border, and one-DIP route-local cadence. The three canonical states
improve from **44,687** to **36,053** aggregate changed pixels, a
**19.321055%** relative reduction. Each state improves by 2,878 pixels, mean
channel delta improves in every state, and WPF/Avalonia painted bounds remain
exactly **421 x 321**.

Only the existing three `font.*` rows change in the canonical comparison; all
288 non-Font rows remain structurally identical. Global accounting remains 141
genuine mismatches, 80 passes, and 70 Avalonia extensions. Checkbox/effect
indicator rasterization and action-row/tab edges remain measured residuals.

## FreeP

Wave 190 added a text-color discriminator to the imported
`IncreasingCircleProcess` source signature, but selected white while the parsed
source resolves to black. The intended Avalonia correction therefore did not
activate on current source. Wave 191 proves the black source color in the corpus
semantic test, corrects the runtime predicate, and retains white and accent-blue
negative controls.

Slide 09 Avalonia/Office improves from **1.6879%** to **0.8675%** and
WPF/Avalonia from **1.6009%** to **0.8540%**; WPF/Office remains **0.9662%**.
Across all 53 Office-backed slides, Avalonia/Office average improves from
**1.0117%** to **0.9962%**, while WPF/Avalonia average improves from **0.6238%**
to **0.6097%**. WPF and measured neighboring controls remain unchanged.

## Focused Verification

- FreeX: physical Linux lane 1/1; cross-platform source/hash guards 4/4;
  focused R89 IO tests 5/5 and final codec/color contract tests 20/20
  on integration, with the worker's broader color IO lane 8/8 and presentation
  color lane 30/30.
- FreeW: planner/raster guards 35/35; Font visual and policy guards 6/6;
  canonical evidence consistency passed. Two broad contract failures are
  byte-identical to `origin/main` and concern Autosave composer expectations and
  the unrelated multilevel-list capture-width adjustment.
- FreeP: full Avalonia renderer suite 290/290 on integration; corpus semantic
  guards 22/22; SmartArt evidence 7/7; full corpus renders 106/106 and diffs
  159/159 in the worker lane.
- Independent review verified the mechanical swatch gate, all committed
  FreeX hashes, the four tracked FreeP PNG hashes, the FreeW whitespace fix, and
  the narrow `.gitattributes` scope. The default lane then exposed two stale
  modeled-boolean expectations and an existing integration-worktree CRLF state.
  The final contract writes explicit `cellColor=1/0`, preserves raw lexical
  precedence, canonicalizes only declared UTF-8 text hashes, and retains strict
  raw hashes for PNG/XLSX evidence.

## Integration Gates

- Cross-app dashboard generation/check, schema validation, FreeW evidence
  consistency, and whitespace validation pass.
- `tools/Test-RepositoryPreflight.ps1`: passed, including all generated parity
  documents and 13,814 conflict-marker-scanned text files.
- `dotnet build FreeX.slnx --configuration Release`: passed with **0 warnings**
  and **0 errors**.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build`:
  passed with solution-level exit **0**. All 25 retained TRX locations report
  `Completed` and zero failures; capture batches intentionally share and
  overwrite one TRX filename.

## Remaining

- FreeX: physical font-color, No Fill, mixed-type, multi-column, and color
  criteria change/clear workflows.
- FreeW: Font checkbox/effect indicator raster tail, action-row/tab template
  edges, Legal Notices glyph/template tail, then classified document residuals.
- FreeP: the remaining IncreasingCircle residual or the Surface3D deck-25
  maximum at 2.5815%, with Office and neighboring control evidence.
