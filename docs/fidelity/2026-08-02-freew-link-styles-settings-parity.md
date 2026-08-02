# FreeW Template Style Refresh Package Parity

## Gap

Microsoft Word persists **Automatically update document styles** as the `w:linkStyles` on/off setting in
`word/settings.xml`. FreeW previously preserved this element only as unmodelled source XML: it could not expose
the setting in `TextDocument`, author it in a new package, or deliberately clear a Word-authored value.

## Implementation

- `TextDocument.AutomaticallyUpdateStylesFromTemplate` models the setting and defaults to `false`.
- `DocxReader` accepts Word's empty, `1`, `true`, and `on` forms as enabled, and its `0`, `false`, and `off`
  forms as disabled.
- `DocxWriter` omits the default from newly authored packages, emits canonical `<w:linkStyles/>` for `true`,
  and overlays or removes the element at its `CT_Settings` schema position in preserved settings XML.

The attached-template relationship remains independently preserved; this slice changes only the setting token.

## Evidence

- Model default and mutation contract: `AutomaticallyUpdateStylesFromTemplateModelTests`.
- Reader/writer package contract: `LinkStylesRoundTripTests` covers canonical emission, default omission, all
  Word on/off lexical forms, two-save stability, reopened model state, and schema-ordered overlay.
