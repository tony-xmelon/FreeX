# Backstage Column Fragment Probe Rejected

## Finding

`backstage-print-preview` and `backstage-pdf-export` have a Word column-flow
residual. On page 1, Word splits body paragraph 8 two lines/two lines across
the columns; FreeW moves the complete four-line paragraph to column two.

The fidelity compositor's diagnostic paginator can identify that paragraph as
crossing the two single-column diagnostic pages, but the detached WPF
`TextPointer` line APIs return empty rectangles and no next-line pointer even
after pagination. They cannot distinguish Word's valid two-line continuation
from a one-line widow.

## Rejected Probe

The probe cleared the production `KeepTogether` approximation for every
implicit-widow paragraph that crossed a same-page column boundary.

Using the persistent matching Word COM PNG corpus at 816x1056, mean absolute
RGB channel delta (0-255; lower is better) improved only the two target page-1
captures:

| Fixture | Page | Baseline | Probe |
| --- | ---: | ---: | ---: |
| Print Preview | 1 | 23.0550 | 21.6110 |
| PDF Export | 1 | 23.0352 | 21.5913 |
| Print Preview | 2-3 | unchanged | unchanged |
| PDF Export | 2-3 | unchanged | unchanged |

However, the same generic policy changed `fixture-columns_p1`. That fixture
has no matching Word PNG in the current persistent corpus, so the change has
no complete control proof. `f2-columns_p1` and `fixture-columns_p2` were
byte-stable, but that is not enough to generalize the policy.

## Conclusion

The candidate was reverted. A valid implementation needs a fragment-aware
pagination signal (or an explicit column-fragment compositor) rather than a
crossing-only or character-count heuristic. The restored Backstage page-1 PNG
SHA-256 is `57633809F91E6470EA015AE2D23CB9BE0B91BB420FFB68D42E83DE5482ADA9F2`,
equal to the pre-probe current-main render.

## Verification

- `dotnet build freew\\tools\\FreeW.FidelityRender\\FreeW.FidelityRender.csproj --configuration Release --no-restore -v:minimal`: 0 warnings, 0 errors.
- Fresh restored composite render matched the prior WPF Backstage page-1 SHA-256.
