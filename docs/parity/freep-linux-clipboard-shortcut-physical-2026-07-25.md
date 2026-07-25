# FreeP Linux Clipboard Shortcut Physical Evidence

This dedicated lane emits exactly eight ordered rows under suite
`freep-linux-clipboard-shortcut-physical`, app surface
`document-editor-clipboard-shortcuts`, category
`physical-x11-clipboard-shortcut`, and evidence level `physical-x11-input`:

- `visible-window-discovery`
- `clipboard-copy-x11-preserves-source`
- `clipboard-paste-native-editable-shape`
- `select-all-multi-shape-mutation`
- `cut-all-x11-undoable`
- `undo-restores-editable-shapes`
- `redo-reapplies-cut`
- `paste-after-cut-restores-editable-shapes`

The fixture is `21-comments-notes.pptx`. Slide 1 starts with one editable shape:
ID 2, name `Notes marker`, text `Slide 1 has speaker notes`, and bounds
`914400,914400,2743200,914400`. The probe records lowercase mounted-file
SHA256 values before any mutation and after the final save. Every intermediate
Ctrl+S checkpoint is copied into the evidence directory before the mounted
presentation can be overwritten again, then inspected with Python standard
library `zipfile` and `xml.etree.ElementTree`.

The physical sequence pointer-selects the baseline shape, copies it through
natural X11 routing, proves the exact `freex.freep.selection.v1` target and
plain text, and hashes the mounted file immediately after Ctrl+C but before
Ctrl+S. That pre-save hash must equal the initial fixture hash, proving Copy
itself did not mutate the package. Ctrl+S is then gated on exact parsed baseline
semantics. Its retained saved-package hash may differ because valid ZIP
timestamps or serialization can change without a semantic mutation. Ctrl+V
must create editable shape ID 3 at the exact 182880-EMU offset. Ctrl+A is
credited only when the following Ctrl+X removes both shapes and one Ctrl+Z
restores both, proving one undoable mutation. Ctrl+Shift+Z must return to an
empty slide. The final Ctrl+V must consume the cut clipboard and create fresh
editable IDs 1 and 2 at the two expected successive offsets. Every checkpoint
requires zero `p:pic` and zero `p:graphicFrame` records.

At the default `1280x820` geometry the probe derives the shape-center click
from the fixed FreeP shell metrics: 180-pixel slide pane, 40-pixel canvas
margin, 60-pixel notes pane, the fixture's 4:3 slide, and the known shape
bounds. The resulting point is approximately `(576,312)` and scales with the
owner geometry. This is a calibration risk if shell chrome dimensions change;
the click and screenshots never prove selection by themselves. Selection earns
credit only through the native clipboard payload and exact saved package
transitions.

The manifest keeps contract validation `pending` for
`tools/Run-FreePClipboardShortcutValidation.ps1` against
`tools/LinuxInteractiveDocker/freep-clipboard-shortcut-validation.schema.json`.
Cleanup fills any unexecuted contract rows with honest failed evidence and
always attempts to write the final mounted hash and eight-row manifest.

Static verification:

```text
bash -n tools/LinuxInteractiveDocker/run-freep-clipboard-shortcut-probe.sh
git diff --check
```
