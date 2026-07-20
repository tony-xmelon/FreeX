# FreeP chart axis `crossBetween` retention

## Scope

PowerPoint-authored chart axes can include `c:crossBetween/@val` with either
`between` or `midCat`, plus category-axis `c:auto/@val` and `c:lblAlgn/@val`.
FreeP previously dropped these tokens during import and had no model state for
the writer or clone path to preserve them.

The chart model now retains the authored values as `ChartAxis.CrossBetween`,
`ChartAxis.AutoCrossing`, `ChartAxis.LabelAlignment`, `ChartAxis.Crosses`,
`ChartAxis.CrossesAt`, `ChartAxis.MajorUnit`, and `ChartAxis.MinorUnit`.
The DOCX-equivalent package path is unchanged: this is a PPTX read/write and
clone parity slice, and the renderer does not reinterpret the token yet.

## Evidence

- `19-chart-labels.pptx` contains `crossBetween="between"`, `auto="1"`, and
  `lblAlgn="ctr"` on its primary axes; reader assertions cover the imported
  tokens, as well as the `autoZero` crossing mode.
- Host round-trip coverage also exercises the `max` crossing mode and a
  numeric `crossesAt` value.
- Host round-trip coverage preserves authored major and minor value-axis
  intervals without inventing units for axes that omit them.
- Host chart round-trip coverage writes and reopens `midCat`.
- The existing chart rendering corpus remains the visual control because the
  change only preserves metadata and does not alter scene planning.

## Guard

Keep `CrossBetween` nullable so charts without an authored token continue to
write the existing omission rather than receiving a guessed default.
