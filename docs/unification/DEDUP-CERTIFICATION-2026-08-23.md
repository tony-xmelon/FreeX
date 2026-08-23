# Deduplication certification - 2026-08-23

## Checkpoint

- Implementation checkpoint: `fe9d2d97ee088f8faaaf9e407020dfde2c573810` on
  `codex/dedup-wave184-20260823`, based on `origin/main` at
  `c7ec0062ec8711a9ce91df345568cdeb94645655`.
- The campaign re-audited the entire production C# tree, not only the renderer roots measured by
  `Measure-DedupResiduals.ps1`. Exact and normalized candidates were reviewed by behavior and ownership.
- All material reusable behavior found by that audit has been extracted or classified. The last actionable
  candidate was XLSX defined-name preservation policy, shared by patch-save and
  rebuild-save while their distinct package mechanics remain local.
- This certification means practical deduplication scope is exhausted. It does not claim zero lexical
  similarity: native renderers, format-specific document rules, compatibility facades, and product catalogs
  intentionally remain separate.

## Campaign result

The campaign added or extended neutral policies, planners, sessions, codecs, and host contracts across these
areas:

- adaptive ribbon, common frame, Backstage panes, status bars, localization mechanics, and dialog policy;
- open/save/recent/recovery/autosave, package streams, OOXML authoring and preservation, export, PDF and print
  orchestration, clipboard/paste placement, and platform file-service selection;
- FreeX formula, conditional-format accessibility, QuickAnalysis, PageLayout, charts, tables, text boxes,
  shapes, pivots, filters, worksheet ordering, and command policy;
- FreeW editing, story/highlight traversal, semantic insertion, undo transactions, pagination, fields, PDF
  projection, dialogs, and application workflows; and
- FreeP slideshow, media, panes, transitions, chart/table/text/shape/SmartArt flows, dialog state, recovery,
  autosave, dictionary storage, and WPF/Avalonia workarea policy.

The largest single change removed the approximately 27,000-line Accessibility formula and conditional-format
shadow engine. Accessibility now evaluates through the canonical Calc/Formula implementation via
`ConditionalFormatEvaluationSession`. Focused reviews also corrected rollback semantics, worksheet drawing
relationship selection, conditional theme-color precedence, and FreeW's effective semantic insertion offset.

## Scope disposition

| Area | Disposition |
|---|---|
| Adaptive WPF/Avalonia ribbon and application frame | Shared policy and definitions; native controls, events, focus, keytips, and layout realization remain renderer leaves. |
| Domain Backstage panes, dialogs, localization, editors, status bars | Shared sessions/planners/contracts; product content and native window construction remain local. |
| Files, open/save/save-as, recent, recovery, autosave, export and print | Shared lifecycle and policy; native pickers, printer backends, streams, and format-specific package mechanics remain local. |
| Scanning | No duplicated cross-app scanning workflow was found. Platform acquisition should be shared when a second product consumer exists. |
| QuickAnalysis, PageLayout, formulas and conditional formatting | Portable FreeX policies own reusable behavior; cell/formula domain semantics remain FreeX-specific. |
| Charts, tables, text boxes, shapes, SmartArt, OLE and media | Shared geometry/OOXML/policy where semantics align; native drawing, real OLE/COM, playback and product document models remain local. |
| Recording | FreeP-only portable policy remains in FreeP until another consumer creates a stable shared contract. |
| XLSX/DOCX/PPTX IO | Common OPC/XML/lexical primitives are shared; distinct standard and preservation rules remain in their format owners. |

An attempted giant FreeP Backstage endpoint factory was rejected because it would have coupled unrelated
commands and hidden product-specific behavior. Likewise, patch-save and rebuild-save retain separate traversal
and writing mechanics around their newly shared defined-name policy. These are deliberate ownership boundaries,
not unfinished extraction work.

## Residual measurement

The deterministic renderer/shared-root scanner now covers 2,541 production C# files and 576,743 code lines.

| Measure | 2026-08-22 baseline | Final checkpoint | Delta |
|---|---:|---:|---:|
| Exact duplicate coverage | 1.254589% | 1.187357% | -0.067232 percentage points |
| Normalized duplicate coverage | 1.523430% | 1.413628% | -0.109802 percentage points |
| Exact duplicate LOC | 7,238 | 6,848 | -390 |
| Normalized duplicate LOC | 8,789 | 8,153 | -636 |
| Measured code LOC | 576,922 | 576,743 | -179 |

Against the merge base, all C# changes total 21,402 additions and 41,409 deletions: a net reduction of 20,007
lines. The scanner deliberately measures renderer, portable-presentation, service, and shared roots; the final
manual audit separately reviewed the full production tree. There are no whole-file exact duplicates.

The leading residual matches are mostly paired WPF/Avalonia control construction, routed/pointer input,
modal/focus lifetime, accessibility attachment, drawing/PDF materialization, slideshow/media realization,
product command/resource catalogs, and schema-shaped package code. Matching text alone is not a neutral
contract. Future extraction requires a reusable behavioral decision, not merely another lexical match.

## FreeX visual validation

The FreeX WPF capture host built with zero warnings and errors. The final run produced all 116 expected PNGs
with no failed captures, missing files, duplicate IDs, or surface-ID drift. Ninety-one surfaces were pixel
identical and all 25 changed surfaces were manually inspected with no blank content, clipping, overlap, missing
controls, stale dialogs, or broken layout.

`dialog.AutoFilter` is the only dimension change (312x475 to 312x481). The strict grid differences for
`grid.demo` (6.068569%) and `grid.sheetTabsOverflow` (5.680394%) are expected adaptive-ribbon/status evolution.
Compared with the preceding 2026-08-23 checkpoint, 114 of 116 images are byte-identical; the two tiny changes
are benign focus/capture variance.

Evidence:

- `C:\Users\anton\AppData\Local\Temp\freex-dedup-visual-20260823-final\report\manual-review.md`
- `C:\Users\anton\AppData\Local\Temp\freex-dedup-visual-20260823-final\report\changed-surfaces.csv`
- `C:\Users\anton\AppData\Local\Temp\freex-dedup-visual-20260823-final\report\manifest-audit.json`
- `C:\Users\anton\AppData\Local\Temp\freex-dedup-visual-20260823-final\report\parity-report.html`

## Verification and residual risk

Focused tests accompanied each extraction. Final repository preflight, Release solution build, default test
lane, UI test lane, generated-document check, and `git diff --check` are the integration gate for this
checkpoint; their final results are recorded in the integration commit and campaign log.

Residual implementation risks are bounded native or contract details, not known duplicate policy: real OLE
COM behavior, direct disposal callbacks, destination-stream length contracts, and source-shape architecture
guards. These should be tested when their owners change.

Re-open dedup work only when new product development creates a second consumer, a behavior change must be
implemented in multiple owners, or the deterministic scanner identifies a new candidate with a stable neutral
contract.
