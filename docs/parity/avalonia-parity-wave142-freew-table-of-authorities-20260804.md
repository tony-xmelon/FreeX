# Avalonia Parity Wave 142: FreeW Table of Authorities

Date: 2026-08-04

## Scope

This slice audits the paired FreeW Table of Authorities dialog scenarios:
`table-of-authorities.initial`, `table-of-authorities.populated`, and
`table-of-authorities.validation-error`. The WPF and Avalonia hosts, the shared
dialog planner, and both visual-harness route adapters were reviewed together.

## Parity improvement

The evidence harness previously gave the Table of Authorities dialog the same
default options for every state. That made the `populated` row a duplicate of
`initial`, and the WPF dialog could not consume the same seeded `ToaOptions`
that Avalonia already accepted.

The shared `TableOfAuthoritiesDialogPlanner` now owns a deterministic
representative populated state: `Statutes`, `Use passim`, `Keep original
formatting`, and `Dashes`. Both WPF and Avalonia route adapters use
`BuildEvidenceOptions`, and the WPF dialog now seeds its controls from the same
options contract. The validation-error state intentionally retains defaults:
this dialog has no free-form input or invalid value that the product can reject.
Avalonia also keeps the shared category and tab-leader choice objects as combo
items, matching WPF's item model rather than binding only display strings.

The Avalonia content inset was adjusted to match the retained WPF painted width
by one pixel. The measured fresh Avalonia bounds are now `x16,y20,513x184`
versus retained WPF authority bounds `x16,y20,513x185`.

## Evidence

Fresh Avalonia captures were nonblank, content-gated, and exited successfully:

| Scenario | Status | Content bounds | Content ratio | Semantics |
| --- | --- | --- | ---: | --- |
| `initial` | captured | `16,20,513x184` | `0.0727529762` | default state; OK/Cancel; both unchecked |
| `populated` | captured | `16,20,513x184` | `0.0729434524` | category index 2; both checked; leader index 1 |
| `validation-error` | captured | `16,20,513x184` | `0.0727529762` | default state; no invalid input exists |

The fresh WPF attempts were run for all three scenarios and rejected by the
visual-content gate: `0.00%` opaque, `100.00%` near-black, no meaningful
painted bounds. They are not visual authority and the retained paired mismatch
ratio remains `0.1135804`; no comparison report row was regenerated from blank
pixels.

## Verification

- Shared planner tests: `7/7` passed.
- WPF Table of Authorities host tests: `7/7` passed.
- Avalonia Table of Authorities visual tests: `2/2` passed.
- Avalonia visual harness build: 0 warnings, 0 errors.
- WPF visual harness build: 0 warnings, 0 errors.
- Fresh Avalonia captures: `3/3` captured and content-gated.
- Fresh WPF captures: `0/3` valid; all rejected and not promoted.

## Residuals

The remaining measured geometry delta is the retained one-pixel height
difference (`184` Avalonia versus `185` WPF). The paired pixel ratio cannot be
recomputed honestly until the WPF raster path produces nonblank output; native
text rasterization and control chrome therefore remain unclassified beyond the
retained comparison.
