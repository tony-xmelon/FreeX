# FreeP chart axis `crossBetween` retention

## Scope

PowerPoint-authored value axes can include `c:crossBetween/@val` with either
`between` or `midCat`. FreeP previously dropped this token during import and
there was no model state for the writer or clone path to preserve.

The chart model now retains the authored value as `ChartAxis.CrossBetween`.
The DOCX-equivalent package path is unchanged: this is a PPTX read/write and
clone parity slice, and the renderer does not reinterpret the token yet.

## Evidence

- `19-chart-labels.pptx` contains `crossBetween="between"` on its primary
  value axes; the reader assertion covers the imported token.
- Host chart round-trip coverage writes and reopens `midCat`.
- The existing chart rendering corpus remains the visual control because the
  change only preserves metadata and does not alter scene planning.

## Guard

Keep `CrossBetween` nullable so charts without an authored token continue to
write the existing omission rather than receiving a guessed default.
