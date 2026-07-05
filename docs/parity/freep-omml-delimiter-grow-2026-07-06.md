# FreeP OMML Delimiter Grow Parity

Date: 2026-07-06

## Scope

This slice adds shared parsing and layout support for OMML delimiter grow behavior:

- `m:dPr/m:grow` is parsed with CT_OnOff semantics.
- Absent `m:grow`, bare/on/true values keep the existing auto-sized delimiter behavior.
- `m:grow` values of `0`, `off`, or `false` keep delimiter glyphs at normal height.
- Tall inner math expressions remain contained in the shared `MathBox` layout even when delimiters do not grow.

The implementation is shared under `FreeP.App.Presentation`; WPF and Avalonia continue to consume the same neutral math box and render-op path.

## Evidence

- Parser coverage: `OmmlParserTests.Delim_WithGrowExplicitlyOff_DoesNotAutoSizeBrackets`
- Parser default/on coverage: `OmmlParserTests.Delim_WithGrowAbsentOrOn_AutoSizesBrackets`
- Layout coverage: `MathLayoutEngineTests.Delim_WithGrowFalse_UsesNormalBracketHeightWithoutClippingTallInnerExpression`

## Remaining Work

PowerPoint-authoritative OMML visual baselines still require a COM-capable validation machine. This slice proves shared WPF/Avalonia behavior for delimiter grow semantics, not full Microsoft PowerPoint math rendering fidelity.
