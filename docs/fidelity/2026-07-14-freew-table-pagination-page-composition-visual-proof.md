# FreeW Table Pagination and Page Composition Visual Proof

Date: 2026-07-14

This slice advances the FreeW WPF/Avalonia visual evidence path for a bounded table/page-composition scenario. It intentionally isolates `TablePaginationPageCompositionProof`, which covers `table-pagination-repeat-header` and `table-page-composition-stress`, and does not include equation, chart, or SmartArt evidence.

The proof is shared-first no-Word fallback evidence. The WPF and Avalonia renderers must both produce trusted rows from the same `FreeW.App.Presentation` table pagination and page-composition plans before the row can be treated as proof-ready. The normalizer records deterministic semantic evidence beyond PNG presence:

- paired trusted WPF and Avalonia rows for both table scenarios;
- table, row, and cell counts for each renderer/page row;
- repeated-header pagination and keep-together row evidence;
- stable table and pagination fingerprints derived from shared table layout and pagination signatures;
- page-composition evidence for page border, watermark, header/footer, PAGE, and NUMPAGES fields;
- explicit `*-word-baseline-fidelity` blockers when Word COM is unavailable.

Run it on a no-Word host with:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File freew-fidelity-corpus\tools\Run-FreeWVisualEvidence.ps1 -OutDir freew-fidelity-corpus\runs\table-pagination-page-composition-proof-20260714-codex -MaxPages 2 -ScenarioSet TablePaginationPageCompositionProof -WordBaselineUnavailableReason "COM ProgID 'Word.Application' is not registered"
```

This remains paired FreeW WPF/Avalonia renderer evidence and Word-baseline readiness only. Because Word COM is unavailable on this host, it does not claim authoritative Microsoft Word PNG table or page-composition parity. Real Word baseline PNG capture and comparison remain required on a machine where `Word.Application` is registered.

Validated on 2026-07-14 with the command above:

- Summary trust: `passed`.
- Evidence rows: `8`.
- Word baseline comparisons: `8`, all `word-baseline-unavailable`.
- Table pagination/page composition proof readiness: `4` trusted scenario rows, `4` verified semantic rows, and `8` verified Word-baseline policy rows.
- Backstage readiness: skipped by scenario filter.
- Summary files: `freew-fidelity-corpus/runs/table-pagination-page-composition-proof-20260714-codex/freew_visual_evidence_summary.{json,md}`.
