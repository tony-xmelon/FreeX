# Avalonia parity Wave 98 integration

Date: 2026-08-01

## Integrated slices

### FreeX nested outline interaction

- Added bounded Linux/X11 physical probes for two-level row and column outline
  grouping, collapsing, and expansion through rendered controls and context-menu
  commands.
- Hardened the probe against false positives by using deterministic worksheet
  origins, structural gutter deltas, exact cell-slot checks, and menu dismissal.
- Made Windows report packaging long-path safe so the detailed selection evidence
  is copied without truncating or silently losing files.
- Final physical Docker run passed 2/2 scenarios. The packaged manifest is
  `artifacts/linux-interactive/freex/interaction-validation/20260801T170145Z/interaction-validation.json`.

### FreeW Legal Notices dialog

- Propagated the shared Avalonia classic-tab header style into the Legal Notices
  dialog and aligned its tab chrome with the WPF route.
- Added bounded one-shot short-document inset compensation instead of cyclic
  vertical centering, which keeps headless layout stable and preserves overflow
  behavior.
- Aligned the short legal-notice content footprint with the WPF baseline using a
  measured 14.6 px line-height compensation.
- The focused Avalonia lane passed 24/24, the WPF help/legal lane passed 9/9,
  and paired captures passed 6/6. Initial/project visual delta improved from
  10.5444% to 9.1022%; all-state delta improved from 15.8870% to 15.4060%.

### FreeP OMML math font

- Shared OMML parsing now preserves `m:mathPr/m:mathFont`, and shared layout
  emits the selected font family on renderer-neutral glyph boxes.
- WPF and Avalonia consume the same `MathBoxRenderPlanner` output through thin
  host drawing adapters.
- Added the evidence row to the FreeP command-inventory generator and its
  generator contract test, keeping generated inventory and dashboard output
  stable at 102 workflow-evidence rows.
- Focused agent verification passed 257/257 presentation math tests, 41/41 WPF
  renderer-host tests, and 42/42 Avalonia renderer-host tests.

## Integration and verification

- Merged 38 concurrent `origin/main` commits across two sync points, including
  FreeP slide-section, chart, and SmartArt work plus FreeW WordArt,
  document-default, and paginated table-spacing work, with no conflicts.
- Repository preflight passed, including generated parity documents and conflict
  marker checks across 10,265 text files.
- `dotnet build FreeX.slnx -c Release` passed across 98 projects with zero
  warnings and zero errors.
- `dotnet test FreeX.DefaultTests.slnx -c Release --no-build --no-restore`
  passed every test assembly; only explicitly skipped benchmark/stress cases were
  skipped.
- After the final 12-commit sync, repository preflight passed again across 10,271
  text files. Rebuilt focused lanes passed 227/227 FreeP presentation tests,
  225/225 FreeP WPF host tests, and 50/50 FreeW document-view tests.
- The final FreeX Linux interaction run used Docker port 6098, stopped its
  container after capture, and left no Wave 98 app process running.

## Remaining depth

- FreeX: extend the physical outline proof to filtered ranges, save/reopen
  retention, and paired WPF physical evidence.
- FreeW: continue the broader visual queue; remaining Legal Notices differences
  are primarily framework glyph, border, tab, and scrollbar pixels.
- FreeP: add document-level `mathPr` inheritance, PowerPoint-authoritative font
  fallback and math metrics, and broader OMML visual baselines.

## Process hygiene

No machine-wide process termination or .NET build-server shutdown was used.
Only two proven Wave 98 headless testhost process pairs were stopped by exact PID
while diagnosing the earlier cyclic-layout attempt. Docker and temporary evidence
cleanup is performed only for paths and images owned by this integration wave.
