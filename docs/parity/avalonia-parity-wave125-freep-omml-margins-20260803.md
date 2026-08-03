# FreeP Wave125 OMML Math Margins

## Authority

- [Microsoft Learn: MathProperties.LeftMargin](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.math.mathproperties.leftmargin?view=openxml-3.0.1)
- [Microsoft Learn: RightMargin](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.math.rightmargin?view=openxml-3.0.1)
- [MS-OE376: dispDef](https://learn.microsoft.com/en-us/openspecs/office_standards/ms-oe376/f5f7b70e-9d07-40f0-b78f-4701a036eef5)

The values are twips. An absent margin element is zero; a present val-less element is 1440 twips. FreeP preserves malformed authored text at the package boundary and applies a zero-margin parser fallback. Math margins are enabled only when the resolved `m:dispDef` is explicitly on. When `dispDef` is off or absent, the margins are ignored and the paragraph layout remains authoritative, matching the supplied Word behavior contract.

## Implementation

- `OmmlMathProperties` carries immutable raw `LeftMargin` and `RightMargin` overlay values. The PPTX reader normalizes val-less elements to `1440` while retaining invalid text for diagnostics and round-trip policy.
- `MathNode.MathProperties` normalizes margins to nonnegative twips. `MathParagraph` receives effective margins only after the `dispDef` gate, so local XML, containing graphic properties, and document defaults remain paragraph-local and precedence-aware.
- `MathLayoutEngine` converts twips to shared presentation DIPs, adds the margins to the bounded paragraph width, and applies the overflow rules: ignore left when left plus right exceeds available width, then use the 1440-twip right fallback when right alone exceeds it.
- `SlideCompositor` supplies the real shape text-area width and existing paragraph left indent to the shared math layout. WPF and Avalonia continue to draw the same renderer-neutral `MathBox` plan.

## Verification

- Presentation parser/layout/integration focus: 325 passed.
- WPF OMML defaults and margin parity focus: 5 passed.
- Avalonia OMML defaults and margin parity focus: 5 passed.
- Coverage includes explicit, absent, val-less, zero, invalid, `dispDef` on/off/absent, document/local overlay precedence, both overflow branches, and host rendering calls.

## Residuals

This slice models the FreeP PresentationML path. It does not add a new writer for a related Word settings part; existing package snapshots remain responsible for preserving unsupported package parts. Paragraph right-margin source data is not a separate DrawingML paragraph property in the current FreeP model, so the OMML right margin is applied against the existing text-area width.
