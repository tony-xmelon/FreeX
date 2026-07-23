# Automatic paragraph spacing retention

## Scope

Word's `w:beforeAutospacing` and `w:afterAutospacing` are semantic overrides: Word ignores the competing
numeric axis and chooses its automatic paragraph spacing. FreeW previously converted those tokens to a
14-point render approximation and wrote that approximation back as ordinary `w:before`/`w:after` values,
losing the source semantics on the first save.

## Change

`ParagraphFormatting` now retains `BeforeAutoSpacing` and `AfterAutoSpacing`. The reader keeps the existing
14-point renderer approximation while recording the source token; the writer emits `w:beforeAutospacing="1"`
or `w:afterAutospacing="1"` and suppresses the conflicting numeric attribute on that axis.

The behavior is implemented for direct paragraph properties, paragraph styles, and `w:docDefaults`.
Ordinary numeric spacing retains the existing numeric serialization.

## Verification

- Focused automatic-spacing tests: 8/8 passed.
- Full `FreeW.Core.IO.Tests`: 1,060/1,060 passed.
- Contracts cover import from `on` and `1` tokens, package XML after save, save/reopen semantics, consecutive
  auto-spacing suppression, numeric-spacing controls, paragraph styles, and document defaults.

No Word COM export was issued because another parity lane currently owns the visible Word instance. The
serialized form is the native WordprocessingML `w:spacing` representation and is asserted directly in the
package tests.
