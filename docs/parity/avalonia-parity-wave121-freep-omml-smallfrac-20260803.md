# Avalonia parity Wave121 FreeP OMML smallFrac - 2026-08-03

## Scope

This slice implements the currently unhandled OMML `m:smallFrac` math
property. The value now survives package/document parsing, containing and
equation-level property inheritance, the framework-free MathNode model, and
the shared MathBox layout consumed by WPF and Avalonia.

## Semantics

- An absent `m:smallFrac` remains absent and preserves the existing layout.
- A present element without `m:val` is on, matching CT_OnOff.
- `1`, `true`, `on`, and `yes` are on; `0`, `false`, and `off` are off.
- Overlay is property-by-property, so an explicit false overrides an inherited
  true value instead of being treated as missing.
- When enabled, numerator and denominator content use script-size geometry in
  stacked `bar`, stacked `noBar`, linear `lin`, and skewed `skw` fractions.
  The linear slash remains full-size as an inline operator.
- When absent or off, the prior geometry remains unchanged.

## Verification

- Shared presentation/parser/reader focus: `275/275` passed.
- Avalonia math baseline class: `44/44` passed.
- WPF math baseline class: `43/43` passed.
- The paired renderer tests assert the same reduced MathBox draw plan and then
  render it through each host.

## Evidence boundary

This is source and renderer-plan parity evidence. No PowerPoint COM or native
PowerPoint pixel baseline was available on this machine, so no native-pixel
claim is made for this OMML property.

## Files

- `freep/FreeP.Core.Model/OmmlMathProperties.cs`
- `freep/FreeP.Core.IO/PptxPackageReader.cs`
- `freep/FreeP.App.Presentation/Math/MathNode.cs`
- `freep/FreeP.App.Presentation/Math/OmmlParser.cs`
- `freep/FreeP.App.Presentation/Math/MathLayoutEngine.cs`
- `freep/FreeP.App.Presentation/SlideCompositor.cs`
- focused shared, WPF, and Avalonia tests
