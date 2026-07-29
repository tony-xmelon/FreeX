# FreeP slide-level external RTF paste - 2026-07-30

## Function slice

FreeP already parsed native RTF while a WPF or Avalonia rich-text editor was active, but
slide-level Paste ignored the platform RTF payload and fell back to plain text. Both desktop
hosts now carry native RTF separately from FreeP's private rich-text clipboard format, read the
Windows and Linux platform aliases, and reuse `ExternalRichTextClipboardPlanner` before the
plain-text fallback.

Pasting RTF from Word or another rich editor therefore creates an editable text box while
retaining the bounded parser's run formatting, paragraph breaks, lists, hyperlinks, and
paragraph layout. FreeP's private selection payload still has precedence, and invalid RTF still
falls through to the existing clipboard decision chain.

## Verification

- WPF native `DataObject` RTF transport and slide-level insertion: 2/2.
- Avalonia platform RTF transport and slide-level insertion: 2/2.
- Existing WPF clipboard class: 39/39.
- Existing Avalonia clipboard interop class: 23/23.
- Release consuming host builds completed with 0 warnings and 0 errors during the focused runs.

This is a functional clipboard interoperability slice. It does not claim inline image/object
embedding inside a `TextBody`; those still require a dedicated inline-object model.
