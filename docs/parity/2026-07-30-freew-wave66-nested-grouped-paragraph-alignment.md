# FreeW Avalonia parity wave 66: nested grouped-child paragraph alignment

Wave 66 closes the nested grouped-child shape-text paragraph-alignment gap.

## Implementation

- `ShapeTextFormattingPlanner` resolves a text-bearing leaf from its root-relative child path,
  and `SetShapeTextParagraphAlignmentCommand` applies Left, Center, Right, or Justify to that
  leaf's own `TextParagraphs` with shared undo/redo semantics.
- WPF and Avalonia keep the owning group as the selection context while routing a nested leaf's
  complete child path to the shared command. Siblings, child offsets, and composed group/leaf
  transforms are outside the command mutation surface.
- Direct shapes retain the existing containing-document-paragraph behavior. They do not switch to
  formatting their shape `TextParagraphs`; nested grouped children are the path-aware exception.
- The Drawing Format surface remains authoritative with Left, Center, and Right. Shared model and
  command tests still cover Justify, but no new Justify ribbon command or registry entry is added.
- The existing Wave 64/65 fixture and validator now accept `nested-text-alignment`; its production
  X11 selector uses the existing Center command, saves and reopens the DOCX, and validates the
  nested child path, alignment, and transforms.

## Verification

- Shared tests cover all four alignments, undo/redo, sibling isolation, and transform preservation.
- WPF tests cover nested routing, direct-shape behavior, and DOCX round-trip persistence.
- Avalonia tests cover the real registry command state and execution for the nested child.
- Linux/X11 physical evidence is produced by the existing
  `Run-FreeWWave64NestedTextValidation.ps1 -Selector nested-text-alignment` lane; execution status
  is recorded with the resulting validation manifest.
