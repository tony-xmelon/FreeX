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
PNG evidence under `artifacts/freex-textbox-inline-edit-physical-wave93/`. The
probe reads the saved drawing XML for the exact authored text, while the opt-in
production observer records editor visibility, focus, automation ID, bounds, and
the live model text. It does not invoke editor methods or test-only seams.

This worktree intentionally does not run Docker. The orchestrator owns serialized
container execution and must report the physical result separately from the focused
source/build verification.
