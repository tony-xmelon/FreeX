# Page-Break Marker Fidelity

## Scope

`references-heavy-fields.docx` renders a forced body page break before the
second page. The live WPF editor draws a gray `#9A9A9A` separator for that
break, but Word's print output has no separator ink in the page body.

## Change

`DocumentView` keeps the existing `BreakPageBefore` pagination behavior and
the live-editor marker by default. The fidelity renderer explicitly disables
only that editor marker for its composite and bare document views.

## Matched Word Evidence

The candidate used the persistent matching Word PNG corpus at 816x1056; no
competing Word COM export was started.

| Fixture | Measurement | Before | After |
| --- | --- | ---: | ---: |
| `references-heavy-fields`, page 2 | Whole page | 7.8224% | 6.1543% |
| `references-heavy-fields`, page 2 | Top marker band `(96,88)-(720,113)` | 1.5843% | 0.0000% |
| `references-heavy-fields`, page 1 | Whole-page control | 0.9800% | 0.9800% |
| `references-heavy-fields`, page 3 | Whole-page control | 5.7081% | 5.7081% |

Pages 1 and 3 are candidate-vs-baseline SHA-256 stable, and page 3 remains
present, proving that the page break itself was retained.

## Verification

`PageBreakRenderTests` passed both a compiling Release run and a Release
`--no-build` run, 3/3. The added contract asserts that disabling the marker
leaves `BreakPageBefore` set while the synthetic top border is absent.
