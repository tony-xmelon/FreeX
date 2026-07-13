# FreeP OMML Sty Bold Rendering - 2026-07-13

Scope: bounded shared FreeP math-rendering slice for PowerPoint-authored OMML runs that use `m:rPr/m:sty`.

## Coverage

- `m:sty m:val="b"` parses as upright and bold.
- `m:sty m:val="bi"` parses as italic and bold.
- Existing `m:sty` plain/italic and `m:nor` upright behavior remains covered.
- `MathBoxRenderPlanner` emits renderer-neutral glyph draw operations with both italic and bold metadata.
- WPF and Avalonia consume the shared bold flag only when creating math glyph typefaces.

## Verification

- `OmmlParserTests.Run_WithStyPlain_IsUprightAndNotBold`
- `OmmlParserTests.Run_WithStyItalic_IsItalicAndNotBold`
- `OmmlParserTests.Run_WithStyBold_IsUprightAndBold`
- `OmmlParserTests.Run_WithStyBoldItalic_IsItalicAndBold`
- `MathLayoutEngineTests.Run_WithBoldStyle_LayoutAndRenderPlanCarryBoldMetadata`
- `MathLayoutEngineTests.OmmlStyBoldItalic_RenderPlanCarriesItalicAndBold`

## Command Inventory

No generated FreeP command inventory update was made. This slice is math glyph rendering, and there is no existing command workflow row for OMML `m:sty` bold/bold-italic consumption.

## Remaining

This does not add PowerPoint COM visual baselines or broaden OMML typography beyond the `p`, `i`, `b`, `bi`, and `m:nor` style flags.
