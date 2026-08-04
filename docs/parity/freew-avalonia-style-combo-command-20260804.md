# FreeW Avalonia paragraph-style combo command parity (2026-08-04)

## Gap

The shared Home Styles group contains a `freew.style` combo in both compiled profiles. WPF registered
the top-level command, but Avalonia registered only quick-style buttons and gallery item commands.
Selecting a value in the Avalonia combo therefore had no command target.

## Change

Avalonia now registers `freew.style` as a `ValueRibbonCommand`. It resolves the combo's display label
against `BuiltInStyles.Gallery` and calls the existing `DocumentView.ApplyNamedStyle` owner path. That
path seeds missing built-in definitions, applies paragraph StyleId through the command bus, handles
multi-paragraph selections, and remains undoable.

Existing quick-style buttons, the richer Styles gallery, Clear Style, New Style, and Manage Styles
commands are unchanged.

## Behavior

- `Heading 1` resolves to style id `Heading1` and applies to the caret paragraph.
- Undo restores the prior null StyleId.
- Unknown, null, and empty combo values are no-ops.
- Registry coverage still requires all gallery item and adjacent Styles commands.

## Verification

- `StylesGalleryTests`: 28/28 compiling focused run.
- The focused build compiled `FreeW.App.Avalonia` and its test assembly successfully.

## Process rule

A compiled combo control and separately-backed gallery items do not prove the top-level value route.
Test the exact display-label-to-model-id mapping, Undo, invalid values, and adjacent registry controls.
