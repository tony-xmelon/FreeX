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

The converter now also resolves a paragraph with no local bullet element through
`TextBody.LstStyle.Resolve(level)`, matching the shared compositor. An explicit
`BulletSuppressed` paragraph still wins over that inherited style. Inherited
character and auto-number markers use the style-level character/number format
and marker typography; image bullets remain payload-owned by the paragraph.

## Verification

- `Converter_RendersListMarkersWithoutAddingThemToLogicalText`: passed.
- `Converter_InheritsListStyleMarkersButHonorsExplicitSuppression`: passed.
- `RichTextEditorTests`: `60/60`.
- `WpfRichTextClipboardAdapterTests`: `23/23`.
- Focused host test lane: `84/84`.
- Consuming `FreeP.App.Host` Release build: passed with 0 warnings and 0 errors.

This is a functional/editor-surface slice; no raster parity claim is attached.
Full list-continuity behavior after arbitrary editing and IME behavior remain
separate deferred scopes.
