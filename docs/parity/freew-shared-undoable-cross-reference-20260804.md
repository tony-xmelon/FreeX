# FreeW Shared Undoable Cross-reference

Date: 2026-08-04

## Scope

WPF cross-reference insertion directly appended both the hidden `_Ref` bookmark and field run, despite
describing the operation as undoable. Avalonia achieved one-step undo with two host-local commands.

Both hosts now consume one shared `InsertCrossReferenceCommand`. The command snapshots the complete
target bookmark-name list and host run list, adds the planned hidden anchor only when needed, and
appends the planned REF/PAGEREF/NOTEREF run. Undo restores both owners exactly; redo reapplies both.
WPF also groups creation of an otherwise missing host paragraph into that same undo step.

## Verification

- Focused shared `CrossReferenceCommandTests`: 1/1 passed for field and auto-bookmark apply, undo,
  redo, sibling-name preservation, and host-text preservation.
- Focused WPF cross-reference coverage: 1/1 passed for cached text/target plus one-step anchor and field
  undo/redo.
- Focused existing Avalonia cross-reference undo coverage: 2/2 passed as the cross-host control.

No Word COM baseline is required because the shared insertion plan, field payload, DOCX serialization,
and rendering are unchanged; this slice fixes command ownership only.
