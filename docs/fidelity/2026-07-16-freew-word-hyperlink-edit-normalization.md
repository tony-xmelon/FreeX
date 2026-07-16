# FreeW Word Hyperlink Edit Normalization

**Date:** 2026-07-16

## Scope

Typing strictly inside an existing Word hyperlink must extend that hyperlink. The resulting text should remain one contiguous hyperlink span when its formatting, comment mark, and revision metadata match.

## Changes

- Routed body text insertion through the existing editable-run normalizer after the low-level insert splits a run around the caret.
- Applied the same link inheritance and normalization rule to table-cell editing.
- Kept the normalizer's existing boundaries for formatting, comments, tracked revisions, format revisions, and tooltip/target differences, so incompatible runs are not merged.
- Updated two stale Avalonia assertions to the already-recorded Word COM scatter palette and centralized ribbon-icon alias policy.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~DocumentViewHyperlinkBookmarkTests|FullyQualifiedName~DocumentViewTableEditTests|FullyQualifiedName~DocumentViewInlineFO4Tests|FullyQualifiedName~RibbonCommandIconPackagingTests|FullyQualifiedName~DocumentViewReviewTests"`
- `dotnet test freew/FreeW.Core.IO.Tests/FreeW.Core.IO.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~Hyperlink"`

The combined Avalonia slice passed 132/132 tests, including new coverage for typing inside a table-cell hyperlink. The DOCX hyperlink IO subset passed 10/10.
