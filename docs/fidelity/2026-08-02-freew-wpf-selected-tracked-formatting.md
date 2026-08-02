# FreeW WPF Selected Tracked Formatting

## Gap

WPF routed `ToggleBold`, `ToggleItalic`, and `ToggleUnderline` directly through `RichTextBox`. The visible
formatting could be committed to the model, but it bypassed FreeW's document command history and could
not author `w:rPrChange` metadata reliably. Native `RichTextBox.Undo()` also left the selected run's
font weight bold in the reproduced undo contract.

## Owner Fix

Non-empty body selections for Bold, Italic, Underline, Superscript, Subscript, Strikethrough, Small Caps,
and All Caps now use a model-backed range command. The command:

- splits only the selected text range while preserving run marks;
- records the active review author and previous formatting when Track Changes and Track Formatting are on;
- preserves an existing formatting revision rather than replacing it;
- restores the exact prior run list on undo;
- reuses the same replacement snapshot on redo, preserving the original revision timestamp; and
- declares `BodyFormatting` mutation ownership for restricted-editing policy.

Collapsed-caret toggles continue through WPF's native routed command so pending formatting for newly typed
text is unchanged.

## Verification

- `DocumentViewTrackEditTests`: 16/16
- Selected Bold exact model + rendered-surface undo/redo contract: pass
- Selected Italic Track Formatting suppression + undo/redo contract: pass
- Selected Superscript tracking + baseline restoration: pass
- Small Caps / All Caps mutual-exclusion contract: pass
- Ribbon, protection, and character-format adjacent suite: 133/134 on the first run; the sole failure was
  a WPF spellchecker COM teardown race in an unrelated SmartArt test, whose exact rerun passed 1/1
- WPF host/test Release build: 0 warnings, 0 errors
