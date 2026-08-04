# FreeW floating-table overlap control

The WPF and Avalonia Table Properties dialogs now expose Word's **Allow overlap** setting when text wrapping is **Around**.

The checkbox is tri-state so package semantics remain exact:

- checked writes explicit `w:tblOverlap w:val="overlap"`;
- unchecked writes explicit `w:tblOverlap w:val="never"`;
- indeterminate preserves the absent/default state.

Choosing text wrapping **None** continues to clear the floating position and overlap payload together. The shared undo command already snapshots both values, so dialog changes remain undoable without losing authored positioning.
