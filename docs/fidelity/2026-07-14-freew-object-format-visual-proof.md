# FreeW object-format no-Word visual proof

This slice advances the FreeW WPF/Avalonia visual evidence path for the bounded `object-format-position-size-style` scenario. It intentionally avoids the equation, chart/SmartArt, grouped drawing-object, and table pagination/page-composition proof rows.

The proof is shared-first no-Word fallback evidence. WPF and Avalonia must both render trusted rows from the same `FreeW.App.Presentation` object-format plan, and the normalizer/runner now require deterministic semantic evidence beyond PNG presence:

- paired trusted WPF and Avalonia rows for `object-format-position-size-style`;
- three floating objects covering image, shape, and WordArt;
- square and top/bottom wrapping, behind/in-front placement, and z-order depth;
- stable object format signatures with kind, wrap, z-order, size, and layer role;
- three alt-text rows for the formatted image, shape, and WordArt;
- shape, image, and WordArt effect evidence, including shadow, glow, reflection, soft edge, bevel, and the GlowDiffused artistic effect;
- explicit `object-format-position-size-style-word-baseline-fidelity` blockers when Word COM is unavailable.

Run it on a no-Word host with:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File freew-fidelity-corpus\tools\Run-FreeWVisualEvidence.ps1 -OutDir freew-fidelity-corpus\runs\object-format-proof-20260714-codex -MaxPages 1 -ScenarioSet ObjectFormatVisualProof -WordBaselineUnavailableReason "COM ProgID 'Word.Application' is not registered"
```

This remains paired FreeW WPF/Avalonia renderer evidence and Word-baseline readiness only. Because Word COM is unavailable on this host, it does not claim authoritative Microsoft Word PNG object-format parity. Real Word baseline PNG capture and comparison remain required on a machine where `Word.Application` is registered.

Expected current no-Word result:

- Drawing/object proof readiness: `1` readiness row, `2` verified semantic rows, and `2` verified Word-baseline policy rows.
- Backstage readiness: skipped by scenario filter.
- Summary files: `freew-fidelity-corpus/runs/object-format-proof-20260714-codex/freew_visual_evidence_summary.{json,md}`.
