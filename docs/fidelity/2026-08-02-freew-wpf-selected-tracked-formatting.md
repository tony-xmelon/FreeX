# FreeW WPF Selected Tracked Formatting

## Gap

WPF routed `ToggleBold`, `ToggleItalic`, and `ToggleUnderline` directly through `RichTextBox`. The visible
formatting could be committed to the model, but it bypassed FreeW's document command history and could
not author `w:rPrChange` metadata reliably. Native `RichTextBox.Undo()` also left the selected run's
font weight bold in the reproduced undo contract.

## Owner Fix

Non-empty body selections for Bold, Italic, Underline, Superscript, Subscript, Strikethrough, Small Caps,
All Caps, Font Family, Font Size, Text Color, Highlight, Character Border, Character Shading, and Clear
Formatting now use a model-backed range command. The command:

- splits only the selected text range while preserving run marks;
- records the active review author and previous formatting when Track Changes and Track Formatting are on;
- preserves an existing formatting revision rather than replacing it;
- restores the exact prior run list on undo;
- reuses the same replacement snapshot on redo, preserving the original revision timestamp; and
- declares `BodyFormatting` mutation ownership for restricted-editing policy.

Collapsed-caret toggles and values continue through WPF's native routed/property command so pending formatting
for newly typed text is unchanged.

## Format Painter Follow-up

WPF Format Painter still applied only the properties exposed by `TextRange.ApplyPropertyValue`, then committed
paragraph formatting separately. That lost Word-only run properties such as character spacing, kerning,
position, ligatures, stylistic sets, number form/spacing, character border/shading metadata, and proofing
language. Run and paragraph changes also were not one command-history entry.

Every live WPF text run now carries the complete resolved model formatting snapshot. `CommitToModel` overlays
the WPF-backed properties onto that snapshot and retains the properties WPF cannot represent directly. Format
Painter applies the captured snapshot through the exact selected-range command, writes tracked `w:rPrChange`
metadata when enabled, applies paragraph formatting in the same undo group, and preserves locked-painter mode.
One Undo or Redo now restores/reapplies both character and paragraph formatting.

## Verification

- `DocumentViewTrackEditTests`: 30/30
- Selected Bold exact model + rendered-surface undo/redo contract: pass
- Selected Italic Track Formatting suppression + undo/redo contract: pass
- Selected Superscript tracking + baseline restoration: pass
- Small Caps / All Caps mutual-exclusion contract: pass
- Selected Font Family and Font Size tracking + exact WPF baseline restoration: pass
- Collapsed-caret Font Family and Font Size native pending-format contract: pass
- Exact selected-character Border and Shading tracking + paragraph restoration: pass
- Exact selected-character Clear Formatting tracking + collapsed-caret paragraph fallback: pass
- Text Color and Highlight exact-range tracking, clear-color restoration, and collapsed-caret pending colors: pass
- Font dialog complete formatting snapshot, advanced typography, undo/redo, and collapsed-caret control: pass
- Live WPF commit preserves the complete model-only run-formatting snapshot: pass
- Format Painter exact-range copy, tracked author/previous-format metadata, and atomic undo/redo: pass
- `ProtectionEnforcementTests`: 12/12
- `FontDialogPolicySourceGuardTests`: 2/2
- `FontDialogPlannerTests`: 22/22
- `FreeWRibbonParityTests`: 104/104
- Ribbon, protection, and character-format adjacent suite: 133/134 on the first run; the sole failure was
  a WPF spellchecker COM teardown race in an unrelated SmartArt test, whose exact rerun passed 1/1
- WPF host/test Release build: 0 warnings, 0 errors
- Current focused tracked/protection/character-format lane: 42/42
- Document round-trip, paged-edit, and reveal-formatting controls: 61/61
- Rebuilt `FreeW.FidelityRender` Release: 0 warnings, 0 errors
- Fresh three-page `references-heavy-fields` WPF composite: all three candidate PNG SHA-256 values are
  byte-identical to the pre-slice current-main control
- A full unfiltered host run exceeded the 240-second command bound; its owned `vstest`/`testhost` children
  were reaped by PID before the bounded 103-test acceptance lanes above were run.
