# Avalonia Parity Wave 175 Integration

Date: 2026-08-22

## FreeX Linux interaction and filter persistence

The production Avalonia desktop passed the authoritative physical selectors at 1280x820 and
96 DPI: outline/filter save-reopen 1/1, grid drag 3/3, and grid AutoFit 3/3. The Linux probe now
avoids redundant X11 synchronization, analyzes mounted screenshots through bounded `/tmp` copies,
and retries the first post-filter clipboard read once without relaxing expected values.

XLSX save now separates runtime-owned filter visibility from explicit filter-hidden state. Supported
criteria no longer emit redundant raw row-hidden bits; explicit fresh-save/imported state keeps its
existing contract; and unsupported native worksheet/table criteria retain the residual raw bits
needed for save-load-save fidelity. The integrated review correction passed 14/14 focused tests and
the complete Core.IO lane at 5,423 passed, 56 skipped, and zero failed.

## FreeW Page Setup focus chrome

Avalonia Page Setup now uses the WPF-native focused-input border token. Four primary states improved
from 9.6771% to 9.6634% changed pixels and from 6.257370 to 6.097939 mean channel delta; the
validation-error state improved from 9.7827% to 9.7690% and from 6.373618 to 6.214187. Focused
verification passed 7/7, and both platform capture sets passed 6/6.

The canonical FreeW evidence remains honest at 291 rows: 141 genuine visual mismatches, 80 passes,
and 70 Avalonia extensions.

## FreeP Surface3D audit

The committed Surface3D corpus still contains only decks 22, 25, and 26 with the same 3x3 topology.
Fresh WPF/Avalonia measurements were unchanged from Wave 174, all 13 render pairs and 26 diffs
completed at 1280x720, and 40/40 focused chart tests passed. The next useful authoritative reference
is a 4x4 no-blank Surface3D mesh; no speculative renderer change was made without it.

## Integration gate

- Repository preflight passed, including generated evidence guards and 13,535 tracked text files
  checked for conflict markers.
- Cross-app dashboard output was regenerated and byte-stable. FreeP evidence remains 33/33 paired
  whole-window captures and 28 passing dialog/pane rows across 123 PNG files.
- `dotnet build FreeX.slnx --configuration Release` passed in isolated serial mode with zero warnings
  and zero errors after the first parallel attempt encountered a transient WPF temporary-file lock.
- The default lane completed with the two filter regressions found during integration corrected and
  revalidated. Its remaining failure is the pre-existing machine-specific headless
  `GridCaptureTests.CaptureGridRange_WritesPngAndJsonLog_ForNewWorkbook` zero-byte PNG.

Wave 175 advances bounded functional and visual parity; it does not claim complete parity for any
of the three applications.
