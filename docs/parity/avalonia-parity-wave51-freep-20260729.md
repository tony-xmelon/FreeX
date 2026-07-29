# FreeP Avalonia Parity Wave 51

## Review comments pane requested state

WPF keeps the Review Comments pane visible after the user opens it on a slide with
no comments. Its visibility is driven by the document state or the explicit
`_reviewCommentsPaneRequested` flag in `freep/FreeP.App.Host/MainWindow.cs`; closing
the pane clears that flag.

Avalonia now mirrors that state. The pane remains visible while empty after an
explicit open, remains visible as comments are added and removed, and stays
closed after the user hides it even when review plans refresh. The workflow is
covered by `Review_comments_pane_preserves_explicit_open_state_for_empty_slide`
in `freep/FreeP.App.Avalonia.Tests/MainWindowHeadlessTests.cs`.

Tests were added but intentionally not run because the release publish is active.
