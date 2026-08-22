# Avalonia Parity Wave178: FreeW Paragraph Dialog

Date: 2026-08-22

## Scope

This slice covers the FreeW Avalonia Paragraph dialog route and its paragraph-only visual evidence. WPF remained the authority. Shared planner/session semantics, validation routing, focus behavior, automation IDs, and keyboard behavior were preserved.

## Evidence

The tracked pre-refresh rows were 380x388. WPF content bounds were 342x326 and Avalonia content bounds were 343x283. The initial/populated row was 16.3599% changed with pHash distance 3; validation-error was 16.8801% changed with pHash distance 3.

Fresh Wave178 authority captures were then taken for `paragraph.initial`, `paragraph.populated`, and `paragraph.validation-error`. Both hosts captured at 380x399. The fresh pre-change comparison measured 17.7259% changed and pHash distance 12 for initial/populated, and 18.2634% changed and pHash distance 12 for validation-error.

The structural cause was Avalonia's local control density and a clipped fixed tab viewport: its 18/22-DIP fields and 253-DIP indents surface ended the painted client surface early. The correction is local to `ParagraphDialog`: 24-DIP WPF-sized fields/actions, a 303-DIP indents surface, and the measured right tab inset. No dialog semantics or shared chrome defaults changed.

## Final Metrics

| Scenario | Changed pixels | Changed ratio | Mean channel delta | pHash | Dimensions | WPF bounds | Avalonia bounds |
| --- | ---: | ---: | ---: | ---: | --- | --- | --- |
| paragraph.initial | 18,844 / 151,620 | 12.4284% | 10.3417 | 2 | 380x399 | 341x337 at 12,12 | 343x337 at 12,12 |
| paragraph.populated | 18,844 / 151,620 | 12.4284% | 10.3417 | 2 | 380x399 | 341x337 at 12,12 | 343x337 at 12,12 |
| paragraph.validation-error | 19,908 / 151,620 | 13.1302% | 11.0566 | 2 | 380x399 | 341x337 at 12,12 | 343x337 at 12,12 |

## Verification

`dotnet test freew\\FreeW.App.Avalonia.Tests\\FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~ParagraphDialogVisualParityTests"`

Result: 8 passed, 0 failed.

The remaining visual gap is the Avalonia painted surface being 2 px wider than WPF in the capture heuristic, plus expected toolkit rasterization differences. The height and pHash alignment improved without changing the authority route or cross-app files.
