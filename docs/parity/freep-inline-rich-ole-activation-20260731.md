# FreeP Inline Rich-Text OLE Activation

Date: 2026-07-31

## Function slice

Inline OLE runs now have the same external activation behavior as slide-level OLE
objects. A double-click on the WPF inline placeholder opens the embedded payload through
the existing temporary-file activation service. Avalonia resolves the clicked `U+FFFC`
marker through the shared rich-text edit buffer before invoking the same service.

The activation service derives a usable extension from the inline file name and, when the
source only supplies a class name, from common Excel, Word, and PowerPoint class names.
When the external application writes a changed payload before closing, the updated bytes
are written back to the live inline run, so committing the rich-text edit preserves the
edited object rather than the original clipboard bytes.

This remains external activation, not in-place OLE hosting inside the text editor. The
replacement-character caret and clipboard contract are unchanged, and unsupported or
empty payloads remain non-activatable.

## Verification

- `OleActivationServiceTests`: inline extension resolution and byte write-back coverage.
- `InCanvasRichTextEditBufferTests`: marker-position lookup returns the owned payload.
- WPF rich-editor tests: 54/54.
- Avalonia rich-editor tests: 29/29.
- Full Presentation tests: 3170/3170.
- Full WPF Host tests: 1850/1850.
- Full Avalonia rendering tests: 194/194.
- WPF and Avalonia Release rendering builds: 0 warnings/errors.

No PowerPoint raster-fidelity claim is attached to this workflow slice.
