# FreeP WPF Rich-Editor List Markers: 2026-08-09

## Scope

The WPF in-canvas rich editor already retained `BulletKind`, character-bullet,
auto-number, restart, and list-level metadata when converting a shape body to
and from a `FlowDocument`, but it did not show those markers while editing.
That left WPF behind the shared/Avalonia rich visual contract for a common
PowerPoint authoring case.

## Implementation

`TextBodyFlowDocumentConverter` now creates tagged `InlineUIContainer` marker
visuals for character bullets, auto-numbered paragraphs, and image bullets.
Numbering uses the existing `PresentationListMarkerContinuationState`, so
restart and continuation semantics remain model-owned. The marker child is
non-hit-testable and the attached marker tag makes it invisible to:

- paragraph text extraction and model run reconstruction;
- logical selection/caret offset conversion;
- WPF rich clipboard selection ranges.

The implementation does not insert marker characters into `Run.Text` and does
not create a second numbering counter. The existing model remains authoritative
when an edit splits or merges paragraphs.

## Verification

- `Converter_RendersListMarkersWithoutAddingThemToLogicalText`: passed.
- `RichTextEditorTests`: `60/60`.
- `WpfRichTextClipboardAdapterTests`: `23/23`.
- Consuming `FreeP.App.Host.Tests` Release build: passed as part of the focused
  test command.

This is a functional/editor-surface slice; no raster parity claim is attached.
Full list-continuity behavior after arbitrary editing and IME behavior remain
separate deferred scopes.
