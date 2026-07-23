# Contextual Paragraph Spacing Retention

FreeW now retains Word's `w:contextualSpacing` as a nullable three-state paragraph setting:

- absent remains absent, leaving inherited style and document-default behavior authoritative;
- an empty token remains enabled; and
- `w:val="0"` remains an explicit disablement.

The reader and writer preserve this state for direct paragraph properties, styles, and document defaults. This matters because Word suppresses before/after paragraph spacing between adjacent paragraphs with the same effective style only when contextual spacing is enabled. The feature is retained as source semantics rather than approximated from numeric spacing, avoiding pagination changes during save/reopen.

Focused package, round-trip, and schema-order coverage validates all three direct states plus style and document-default serialization. Word COM rendering was not started for this package-semantic slice because the shared Word process remains owned by the active watermark export lane.
