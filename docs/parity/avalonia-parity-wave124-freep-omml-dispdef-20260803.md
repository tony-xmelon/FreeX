# Wave124 FreeP OMML `m:dispDef`

This bounded slice adds document-level OMML display-default gating through the
FreeP package model, shared parser context, compositor, and WPF/Avalonia math
render plans.

## Behavior

- `OmmlMathProperties.DisplayDefaults` and the immutable
  `MathNode.MathProperties.DisplayDefaults` preserve absent versus authored
  `m:dispDef` values.
- `m:dispDef` uses CT_OnOff semantics: val-less and invalid authored values
  resolve on; `0`, `false`, and `off` resolve off; absence remains absent.
- An absent or off `m:dispDef` disables `m:defJc`, matching Word's documented
  behavior. An on value enables inherited/local `m:defJc` again.
- `m:oMathParaPr/m:jc` remains a paragraph setting and continues to override
  `m:defJc` even when display defaults are enabled.
- Document settings are read from the related settings part and flow through
  the existing compositor conversion. WPF and Avalonia consume the same
  renderer-neutral `MathBox` plan.

Margins and wrapping properties named by the Microsoft interoperability note
are intentionally outside this bounded slice because FreeP does not yet model
the corresponding paragraph settings. No host-specific layout branch was
added.

## Evidence

- Shared parser tests cover absent, off, on, val-less, invalid, inherited, and
  local `m:dispDef` values, plus paragraph-level `m:jc` precedence.
- Package integration tests cover settings-part propagation and absent-value
  preservation.
- Paired WPF and Avalonia tests cover visible right alignment when display
  defaults are on and centered paragraph-default behavior when `m:dispDef` is
  absent.

## Authority

- [Open XML SDK `DisplayDefaults`](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.math.mathproperties.displaydefaults?view=openxml-3.0.1)
- [MS-OE376 `dispDef`](https://learn.microsoft.com/en-us/openspecs/office_standards/ms-oe376/f5f7b70e-9d07-40f0-b78f-4701a036eef5)

The Microsoft interoperability note states that when `dispDef` is off Word
ignores `defJc`, `lMargin`, `rMargin`, `wrapRight`, and `wrapIndent` and uses
paragraph settings instead. This implementation intentionally claims only the
`defJc` portion of that rule.
