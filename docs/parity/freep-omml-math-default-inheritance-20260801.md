# FreeP OMML Math Property Inheritance - 2026-08-01

## Scope

This slice adds shared inheritance for OMML `m:mathPr` defaults:

- The parser reads a `m:mathPr` from the containing math graphic context and
  accepts caller-supplied document defaults for contexts that are stored
  outside the preserved math run XML.
- Properties are resolved independently. A nearer math property overrides only
  the values it supplies, then paragraph `m:oMathParaPr` break properties take
  precedence over math-property break defaults.
- Non-empty `m:mathFont` reaches both inline and paragraph math through the
  renderer-neutral `MathNode` and `MathBox` plan consumed by WPF and Avalonia.
- Empty `m:mathFont` values remain non-effective and inherit the next available
  font, preserving the existing caller-font fallback behavior.

## Verification

- Parser coverage: `OmmlParserTests.OMathPara_InheritsGraphicMathPropertiesByProperty`
  and `OmmlParserTests.InlineOMath_InheritsGraphicMathFontIntoSharedRoot`.
- Layout coverage:
  `MathLayoutEngineTests.OmmlDocumentMathProperties_InheritAndOverrideBeforeSharedLayout`.
- WPF renderer coverage:
  `SlideCanvasMathBaselineTests.RenderParaWithMath_DocumentMathProperties_UsesInheritedFontPlan_DoesNotThrow`.
- Avalonia renderer coverage:
  `SlideCanvasMathBaselineTests.RenderParaWithMath_DocumentMathProperties_UsesInheritedFontPlan_DoesNotThrow`.

## Remaining

This is shared structural and render-plan evidence. It does not claim
PowerPoint-authoritative default propagation, settings-part package corpus
coverage, exact font fallback, Cambria Math metrics, or full OfficeMath
property coverage beyond the currently modeled binary-break and math-font
values.
