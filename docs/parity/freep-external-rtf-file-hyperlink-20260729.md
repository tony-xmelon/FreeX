# FreeP external RTF local-file hyperlinks - 2026-07-29

## Function slice

The bounded external RTF planner now applies the shared external-URI policy to `HYPERLINK`
fields. Local `file:` targets such as `file:///C:/Reports/budget.xlsx` survive paste as
activatable run hyperlinks, including when the field is the final content in the RTF stream.
Remote file hosts such as `file://server/share/budget.xlsx` are retained as text but do not
become active links.

This keeps the private FreeP clipboard payload first in the precedence chain and does not widen
the existing unsafe-scheme boundary. The shared WPF/Avalonia hyperlink dialog and slideshow
launcher use the same local-file policy.

## Verification

- `ExternalRichTextClipboardTests`: 18/18.
- Combined external RTF and hyperlink-dialog planner filter: 37/37.
- The focused test also covers a terminal local-file field and a remote file-host rejection.

This is a functional clipboard interoperability slice; it makes no visual-rendering claim.
