# FreeW Inline Equation Content-Control Package Round Trip - 2026-08-02

## Scope

This bounded package-parity slice recognizes the WordprocessingML
`w:sdtPr/w:equation` discriminator as `ContentControlKind.Equation` for inline
content controls. It does not add a block-level equation-control kind, equation
editing behavior, or rendering behavior.

## Model And IO Contract

- An inline `w:sdt` with `w:sdtPr/w:equation` imports as an explicit
  `ContentControlKind.Equation` on every owned run.
- Existing OMML content continues through the normal `Run.Equation` path. The
  content-control kind and the OMML equation payload are independent marks on
  the same run.
- The canonical writer emits an empty `w:equation` child in `w:sdtPr` and keeps
  the equation payload as `m:oMath` inside `w:sdtContent`.
- An ordinary `w:richText` control remains `ContentControlKind.RichText` and is
  written with `w:richText`, never `w:equation`.
- An inline control with no explicit kind marker retains the existing conservative
  plain-text fallback and canonicalizes to `w:text` on save.

## Verification Contract

`EquationContentControlRoundTripTests` uses one exact package fixture containing
an OMML equation control, an ordinary formatted rich-text control, and a control
with no kind marker. It verifies exact source and canonical equation SDT XML,
the imported and reopened models, first-save to second-save canonical SDT
stability, the rich-text/absent-kind controls, and Microsoft 365 Open XML schema
validation of the source and both saved packages.

`EquationContentControlModelTests` anchors the explicit enum value on an inline
OMML run and confirms the existing rich-text factory remains unchanged.
