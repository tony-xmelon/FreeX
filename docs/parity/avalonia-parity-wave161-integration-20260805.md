# Avalonia parity Wave161 integration
Date: 2026-08-05

## Integrated slices

- **FreeX:** PivotChart field-button context menus now derive unique Avalonia gestures from the same
  shared keytip algorithm used by WPF. Open-menu routed dispatch, disabled items, Escape, and outside-menu
  scope are covered. Linux production validation passed all 19 PivotChart rows.
- **FreeP:** the shared XamlPackage writer now preserves strikethrough alone and together with underline.
  Shared round-trip, native WPF save/load, and Avalonia production `DataTransfer` evidence all passed.
- **FreeW:** a fresh paired Backstage Open run captured both hosts and found no semantic or actionable
  structural discrepancy. The trial production change was removed; the retained evidence reports the
  genuine 10.89375% toolkit-rendering mismatch without changing thresholds or classifications.

## Verification

- Repository preflight: passed, including generated documents, cross-app dashboard guards, FreeP visual
  evidence, and the FreeW canonical **159 mismatch / 24 pass / 105 extension / 7 N/A** counts.
- Full `FreeX.slnx` Release build: passed with **0 warnings and 0 errors**.
- FreeX Wave161 routed interaction class: **3/3 passed**.
- FreeP Wave161 focused evidence: shared **1/1**, native WPF **2/2**, Avalonia production transfer **1/1**.
- Linux Docker context catalog: **19/19 PivotChart rows passed**. The full catalog's 54 failures are the
  existing Worksheet Show Notes and AutoFilter criteria command/aggregate clusters, not PivotChart.
- Default non-UI lane: the solution wrapper completed ten project TRXs before its 20-minute ceiling while
  the large Avalonia assembly was still active. Complete follow-up coverage passed:
  - Avalonia `ParityCaptureTests`: **18/18**; all other Avalonia tests: **2,039/2,039**.
  - Host Logic non-clipboard cohort: **1,468/1,468**, plus **4 benchmark skips**; clipboard cohort:
    **30/30**. Two different OS-clipboard tests each failed once in long mixed runs and passed immediately
    alone; the isolated cohorts remove that external clipboard contention.
  - Every remaining default test project passed against the same full-build binaries.

## Honest residuals

- FreeX native X11 letter injection and gesture-text pixels remain unproved for the new keytips. The Linux
  production routes are proved, and the 54 unrelated context results provide the next functional backlog.
- FreeP OLE, unsupported FlowDocument controls/resources, and unsupported image MIME types remain in the
  private payload only.
- FreeW retains 159 genuine paired visual mismatches; this wave prevents an evidence-neutral production
  tweak rather than reducing that count.
