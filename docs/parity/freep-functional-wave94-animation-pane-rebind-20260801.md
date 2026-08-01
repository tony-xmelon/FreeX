# FreeP functional parity Wave 94: Animation Pane rebind

Date: 2026-08-01

## Selected gap

The WPF host rebuilds its visible Animation Pane after New/Open in
`FreeP.App.Host.MainWindow.LoadModel`. Avalonia rebuilt the editor and canvas, but
left the existing pane controls and timeline projection in place. After replacing
a presentation, a user could therefore see animation rows from the previous deck;
the stale row also retained controls that no longer described the active model.

This is a runtime lifecycle asymmetry, not a command-presence gap. The generated
command inventory already reports the Animation Pane command in both hosts.

## Closure

Avalonia now clears the transient animation selection and playback plans during
presentation replacement, then refreshes the visible pane from the new editor.
Hidden panes remain lazy and build their current projection when next shown.

## Evidence

`MainWindowHeadlessTests.New_WhileAnimationPaneVisible_RebindsPaneToNewPresentation`
creates an animation, opens the pane, invokes the production async New workflow with
a discard decision, and proves that the old row is gone while the new empty
presentation renders its empty-state row. The WPF counterpart already rebuilds its
visible pane in `RebuildAnimationPaneIfVisible()` from `LoadModel`.

Focused verification:

```text
dotnet test freep/FreeP.App.Avalonia.Tests/FreeP.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~New_WhileAnimationPaneVisible_RebindsPaneToNewPresentation" --logger "console;verbosity=minimal"
```

## Residuals

This closes the New/Open lifecycle rebind for the in-window Avalonia Animation Pane.
It does not claim PowerPoint-authoritative animation rendering, full physical X11
coverage of every pane control, or parity for unrelated native recording and media
capture boundaries.
