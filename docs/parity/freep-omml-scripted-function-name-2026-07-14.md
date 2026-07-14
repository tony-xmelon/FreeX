# FreeP OMML Scripted Function-Name Semantics - 2026-07-14

## Scope

This slice advances shared FreeP OMML math parity for function application names that are themselves structured math objects, such as `sin^2 x` and `lim_{x->0} f(x)`.

The implementation stays renderer-neutral:

- `OmmlParser` normalizes nested `m:func/m:fName` operator-name bases to upright math runs when they appear under `m:sSup`, `m:sSub`, `m:sSubSup`, `m:limLow`, `m:limUpp`, `m:box`, or `m:argPr` wrappers.
- `MathLayoutEngine` continues to consume the same `MathNode.Func`, `MathNode.Sup`, and `MathNode.Limit` structures without WPF/Avalonia branching.
- WPF and Avalonia baseline tests assert the same `MathBoxRenderPlanner` glyph plan before drawing.

## Evidence

- Parser tests cover scripted and lower-limit function names while keeping the applied argument as ordinary math-run styling.
- Layout tests prove the shared draw plan carries `sin`, `2`, and `x` in the expected order, with the function-name base upright and the argument italic.
- WPF and Avalonia smoke tests render the shared scripted-function plan through each host without introducing host-specific math policy.

## Remaining Work

This is not a PowerPoint-authoritative visual parity claim. Exact Cambria Math glyph shaping, OfficeMath function-name spacing, and PowerPoint-rendered baselines still need capture on a COM-capable PowerPoint baseline machine.
