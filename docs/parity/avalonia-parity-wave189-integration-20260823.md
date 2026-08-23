# Avalonia Parity Wave 189 Integration

Date: 2026-08-23

Wave 189 processes one bounded slice per application and brings the cumulative
app-slice count to **567**. Generated command inventories continue to report
zero actionable Avalonia-missing commands across FreeX, FreeW, and FreeP. The
remaining work is physical workflow coverage and measurable visual fidelity,
not command-id coverage.

## FreeX

The production Linux X11 date AutoFilter lane adds a deterministic typed-date
XLSX fixture and strict Before/After save/reopen probes through the rendered B1
glyph. Before February 1 passes end to end: visible rows are `Jan01,Jan15`, the
saved package contains `operator=lessThan,value=45323`, and reopen reproduces
the same rows.

After February 1 remains uncredited. The rendered criterion retains `Mar15`,
save reaches a clean title, and OOXML contains
`operator=greaterThan,value=45323`, but the second production Open dialog does
not appear. The runner reports every subcondition separately and keeps reopen
acceptance strict. No speculative product change was made. Focused source
guards pass **2/2**.

## FreeW

The Avalonia Font dialog now requests grayscale text antialiasing at its route
boundary to match the WPF capture authority without changing shared compact
dialogs. Fresh three-state aggregate changed pixels improve from **58,705** to
**57,620**, a further **1.848%** reduction, and every state improves. All three
remain genuine visual mismatches.

Focused Font visual tests pass **4/4**, shared planner tests pass **31/31**, and
both WPF and Avalonia harnesses build with zero warnings and errors. The
canonical report remains 512 scenarios, 141 genuine mismatches, 80 passes, and
70 classified Avalonia extensions.

## FreeP

Avalonia now consumes Wave188's semantic imported
`IncreasingCircleProcess` cache flag for a route-scoped Aptos fallback
calibration. Slide 09 Avalonia/Office improves from **1.6879%** to **1.5440%**
and WPF/Avalonia improves from **1.6009%** to **1.3657%**. WPF/Office remains
**0.9662%**. Neighboring SmartArt slides, deck-14 SmartArt, deck-26 Surface3D,
ordinary authored labels, and non-Aptos text remain controls.

Avalonia rendering tests pass **286/286**, focused SmartArt presentation tests
pass **434/434**, renderer evidence tests pass **7/7**, and RenderCompare builds
with zero warnings and errors.

## Integration Gates

- Repository preflight passed across 270 JSON files, 306 XML-backed files, 111
  PowerShell scripts, 160 projects, generated parity documentation, and the
  conflict-marker scan over 13,785 text files.
- `dotnet build FreeX.slnx --configuration Release` passed with zero warnings
  and zero errors in 1 minute 22 seconds.
- `dotnet test FreeX.DefaultTests.slnx --configuration Release --no-build`
  passed. The final FreeX Avalonia assembly completed 2,162/2,162 tests; all
  other completed default-lane assemblies were also green, with benchmark-only
  skips retained.
- Cross-app dashboard generation, check mode, schema validation, evidence
  aggregation guards, and whitespace validation passed before push.

## Remaining

- FreeX: resolve the second-cycle Open/modal blocker for Date After, then cover
  color, mixed-type, multi-column, and criteria clear/reapply workflows.
- FreeW: Font control-template and Legal Notices glyph/template tails, plus the
  remaining pagination, drawing/object, chart, table, and WordArt mismatches.
- FreeP: the remaining imported SmartArt target residual or a genuinely new
  Surface3D/SmartArt topology while preserving Office and control metrics.
