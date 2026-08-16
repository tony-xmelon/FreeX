# FreeW Whole-Window and Chrome Evidence

This bundle makes the FreeW desktop-shell evidence uniform across the two application hosts. It is **not** a Microsoft Word visual-parity report: Word document-page baselines remain separately tracked under docs/parity/freew-word-baseline-2026-08-16/, and no native Word ribbon/chrome capture is claimed here.

## Coverage

| Evidence family | WPF | Avalonia | Result |
|---|---:|---:|---|
| Static whole-window ribbon/chrome (10 tabs x 4 widths) | 40 | 40 | 40 paired captures, visual review required |
| WPF contextual ribbon tabs | 32 | 0 matched contextual-state captures | Explicit coverage gap; not represented as a parity pass or mismatch |
| Backstage / app dialogs | Existing dialog harness | Existing dialog harness | Outside this shell-only matrix |
| Microsoft Word chrome | 0 | n/a | No reference artifacts captured |

Widths are 1500, 1100, 900, and 750 DIPs; every capture is 720 DIPs high. WPF uses the real FreeW.App.Host.MainWindow via FreeW.RibbonShot; Avalonia uses the real FreeW.App.Avalonia.MainWindow through an actual Skia headless compositor frame.

## Classification

The 40 static rows are intentionally paired-capture-review-required, not pixel passes. The two hosts have deliberate structural chrome differences (native frame, title/QAT arrangement, and compact toolbar layout), so a raw whole-window pixel threshold would report implementation-independent differences as product failures. Each artifact is hash-listed in reew_shell_visual_evidence.json and must exist and be non-empty for generation/check to pass.

The 32 WPF contextual-tab images are retained as real WPF shell evidence. Avalonia's normal seeded document has no table/picture/chart/SmartArt selection, so this capture does not invent an Avalonia counterpart. Adding matching state-fixture activation is the next remaining FreeW shell-capture task.

## Reproduce and Check

``powershell
dotnet run --project freew/tools/FreeW.ShellVisualHarness.Avalonia/FreeW.ShellVisualHarness.Avalonia.csproj -c Release -- --output docs/parity/freew-shell-visual-2026-08-16/avalonia
# For each width 1500, 1100, 900, 750:
dotnet run --project freew/tools/FreeW.RibbonShot/FreeW.RibbonShot.csproj -c Release -- docs/parity/freew-shell-visual-2026-08-16/wpf/<width> all <width> 720
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Generate-FreeWShellVisualEvidence.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Test-FreeWShellVisualEvidence.ps1
``

The source hashes, row inventory, PNG hashes, and sizes are generated into reew_shell_visual_evidence.json. -Check is byte-for-byte against both generated files.