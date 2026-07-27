# Avalonia Parity Wave 39

Date: 2026-07-27

## Closed Production Slices

### FreeX

New Note, Edit Note, Shift+F2, and worksheet-context note commands now use the
worksheet-anchored inline editor on Avalonia, matching the WPF production
workflow. Save, cancel, focus restoration, initialization, and undo are covered.

Verification:

- Avalonia inline review runtime tests: **5/5 passed**.
- WPF review and shortcut authority tests: **124/124 passed**.

### FreeW

Avalonia now registers and executes the WPF Picture Format adjustment, color,
transparency, effect, and artistic-effect command IDs through the shared
undoable model. Correction and recolor presets render through an Avalonia pixel
pipeline aligned to the WPF operation order. Bitmap ownership, cache
invalidation, disposal, and premultiplied alpha are covered.

Verification:

- Avalonia picture command and bitmap tests: **11/11 passed**.
- WPF image-adjust authority tests: **12/12 passed**.

### FreeP

The WPF and Avalonia transition-sound pickers now consume one shared media file
type catalog. Both hosts expose MP3, M4A, WAV, WMA, AAC, OGG, and FLAC.

Verification:

- Shared catalog tests: **2/2 passed**.
- Avalonia picker wiring test: **1/1 passed**.
- WPF picker wiring test: **1/1 passed**.

## Remaining Depth

- FreeX inline-note pixel placement and styling need a paired foreground
  WPF/Avalonia capture.
- FreeW shadow, glow, soft-edge, bevel, and artistic-effect model commands are
  functional and undoable, but most still need Avalonia rendering. Reflection
  variants beyond the existing preset also remain.
- FreeP native picker chrome and installed codec support remain platform-owned;
  the accepted file-type contract is now shared.

The broader 100% parity goal remains active. Wave 39 closes three bounded
production differences; it does not claim whole-app parity.
