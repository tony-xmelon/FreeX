# Avalonia FreeP rich clipboard Wave 158

Date: 2026-08-05

## Scope

The WPF WpfRichTextClipboardAdapter publishes native Rtf, native
XamlPackage, Unicode text, and the private FreeP rich payload on copy. Before
this wave, Avalonia's in-canvas rich editor published only the private FreeP
payload and plain text. That left copy from a Linux Avalonia editor opaque to
WPF, Office, and other standard rich-text consumers.

## Implemented

- Added ExternalRichTextClipboardPlanner.SerializeRtf, a shared bounded RTF
  projection for the renderer-neutral InCanvasRichClipboardPayload.
- The projection preserves modeled fonts, font sizes, resolved colors, bold,
  italic, underline, strike, caps, character direction, baseline direction,
  paragraph alignment/direction, indentation, spacing, tab stops, bullets, and
  external hyperlink fields.
- Avalonia's real rich-editor copy/cut transfer now publishes:
  - the private FreeP payload for lossless in-app resources;
  - Rich Text Format on Windows or text/rtf on Linux for standard
    interoperability;
  - Unicode text as the final fallback.
- Paste ordering remains unchanged: the private FreeP payload wins inside
  FreeP, then XamlPackage, then standard RTF, then plain text.
- XamlPackage was not fabricated on Avalonia. Inline tables, OLE, images, and
  other FreeP-only resources remain in the private payload and are not claimed
  as portable RTF features.

## Verification

Commands were run in the assigned linked worktree with foreground serial
verification:

- dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~ExternalRichTextClipboardTests": 54/54 passed.
- dotnet test freep\FreeP.App.Rendering.Avalonia.Tests\FreeP.App.Rendering.Avalonia.Tests.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~AvaloniaRichTextEditorTests": 39/39 passed.
- dotnet test freep\FreeP.App.Host.Tests\FreeP.App.Host.Tests.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~WpfRichTextClipboardAdapterTests": 15/15 passed.
- dotnet build FreeP.slnx --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1: succeeded with 0 warnings and 0 errors.
- git diff --check: passed.

The new shared test round-trips a mixed-font, colored, bold/underlined,
italic/struck, RTL, paragraph-aligned, and hyperlink-rich payload through the
writer and existing parser. The Avalonia test reads the exact RTF bytes from
the transfer produced by the production copy helper and parses them through
the same shared path.

## Residuals

- Avalonia does not emit WPF XamlPackage; no portable Avalonia equivalent was
  invented.
- RTF carries the text/run/paragraph projection only. FreeP-only inline
  tables, OLE objects, images, field runs, rich effects, and native package
  resources continue to require the private FreeP clipboard format. Character
  bullets and basic decimal numbering are projected; every PowerPoint-specific
  AutoNumType is not claimed as an exact RTF round-trip.
- Physical Linux clipboard-manager and WPF/Office round-trip validation still
  requires an attached desktop clipboard and the corresponding host
  applications; the managed transfer and parser contracts are covered here.
