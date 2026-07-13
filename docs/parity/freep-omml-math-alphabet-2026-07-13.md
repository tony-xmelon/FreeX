# FreeP OMML Math Alphabet Rendering - 2026-07-13

Scope: bounded shared FreeP math-rendering slice for PowerPoint-authored OMML runs that use `m:rPr/m:scr`.

## Coverage

- Parses `m:scr m:val` values for `roman`, `script`, `fraktur`, `double-struck`, `sans-serif`, and `monospace`.
- Unknown or absent `m:scr` values keep the existing default run style.
- `MathNode.Run` carries the requested math alphabet through the shared model.
- `MathLayoutEngine` maps simple ASCII letters and digits into deterministic mathematical alphanumeric Unicode glyphs where the requested alphabet has code points.
- Unsupported characters remain unchanged.
- Explicit math alphabet glyphs replace renderer font-style policy, while `roman` and default runs preserve existing bold/italic metadata.
- WPF and Avalonia consume the same existing `MathBoxRenderPlanner` glyph draw operations without renderer-local alphabet policy.

## Verification

- `OmmlParserTests.Run_WithScr_MapsKnownMathAlphabet`
- `OmmlParserTests.Run_WithUnknownScr_UsesDefaultAlphabet`
- `MathLayoutEngineTests.Run_WithMathAlphabet_MapsAsciiGlyphsInSharedDrawPlan`
- `MathLayoutEngineTests.OmmlScrDoubleStruck_RenderPlanUsesUnicodeMathGlyphs`
- `MathLayoutEngineTests.Run_WithRomanAlphabet_PreservesExistingItalicAndBoldBehavior`

## Command Inventory

No generated FreeP command inventory update was made. This slice is shared OMML parsing/layout/render planning, not a command workflow surface.

## Remaining

This does not add PowerPoint COM visual baselines, exact font metric parity, or broader OfficeMath typography beyond the common `m:scr` math alphabet values.
