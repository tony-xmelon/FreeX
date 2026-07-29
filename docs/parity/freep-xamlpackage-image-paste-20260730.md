# FreeP XamlPackage image paste

Date: 2026-07-30

## Change

The shared XamlPackage clipboard path now resolves an explicitly referenced WPF
Image.Source from the package resource entries, including data URI sources.
Image-only packages paste as an editable picture shape. Packages containing both
projected FlowDocument text and an image preserve both payloads as separate
editable shapes.

The existing paragraph, run, table, formatting, RTF, plain-text, and malformed
package fallbacks remain unchanged. Resource lookup is bounded by the existing
clipboard package and resource limits and does not scan unrelated media entries.

## Verification

- OsClipboardServiceTests.Paste_XamlPackage*: 2/2
- Release consuming host build: 0 warnings, 0 errors

## Boundary

Inline image placement inside a text box, resource dictionaries, controls, and
full FlowDocument geometry remain outside the renderer-neutral TextBody model.
Those require a shared inline-object clipboard contract rather than silently
flattening an image into text.
