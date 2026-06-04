# Format Cells Special Friendly Labels

## Goal

Bring the Format Cells > Number > Special catalog closer to Excel by showing user-facing labels while preserving the existing custom number-format codes.

## Scope

- Show friendly Special labels: Zip Code, Zip Code + 4, Social Security Number, Phone Number.
- Keep persisted/applied format codes unchanged.
- Cover label-to-code resolution with App.Host tests.
- Update command parity and architecture documentation.

## Verification

- Focused Format Cells dialog test.
- Full solution build with shared build servers disabled.
