# FreeX Wave 93: Drawing TextBox Inline Editing on Linux/X11

This lane validates the production Avalonia FreeX drawing TextBox editor through a
foreground X11 desktop. It opens a deterministic XLSX fixture containing a real
`txBox="1"` drawing object, double-clicks the rendered object, proves the real
`TextBoxInlineEditor` has focus and nonzero bounds, types multiline content with
modified Enter, commits with Tab, and cancels a second edit with Escape.

Run from the repository root in the serialized Docker validation slot:

```powershell
powershell -File tools/Run-FreeXTextBoxInlineEditPhysicalLinuxValidation.ps1
```

The wrapper writes `results.json`, `runtime-observations.json`, the strict schema,
the deterministic fixture, and before/editing/editing-multiline/committed/canceled
PNG evidence under `artifacts/freex-textbox-inline-edit-physical-wave93/`. Before
interaction, the probe reads the fixture drawing XML to establish input provenance.
Commit and cancellation are then proved from exact opt-in live model observations
plus screenshots; this interaction lane does not save the workbook because Ctrl+S
can legitimately route a loaded fixture through the native Save As flow. The
observer emits only after the editor has positive laid-out bounds, and it does not
invoke editor methods or test-only seams.

This worktree intentionally does not run Docker. The orchestrator owns serialized
container execution and must report the physical result separately from the focused
source/build verification.
