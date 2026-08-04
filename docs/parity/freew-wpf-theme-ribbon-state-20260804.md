# FreeW WPF theme ribbon state parity (2026-08-04)

## Scope

The WPF Design `Themes` combo already applied a selected `DocumentTheme`, but it did not publish the
document's current theme back to the shared ribbon state store. The command now implements
`IRibbonStatefulCommand` and reports `TextDocument.Theme.Name`.

The state is seeded when the registry is built and refreshed by the existing selection/layout state
pipeline. Opening a document therefore shows its loaded theme, and applying a new theme updates the
combo without a separate shadow setting.

## Behavior

- A new document reports `Office`.
- Selecting `Berlin` applies that theme and reports `Berlin`.
- Loading a document whose model theme is `Ion` reports `Ion`.
- An unknown nonempty value remains a no-op and preserves `Ion`.

## Verification

- `RibbonComboCommandContractTests`: 3/3 compiling run and 3/3 no-build run.
- `DocumentThemeTests`: 17/17.

## Process rule

Ribbon combo state must come from the authoritative document model, not a host-local last-selection
cache. Test initial, applied, loaded, and invalid-value behavior together.
