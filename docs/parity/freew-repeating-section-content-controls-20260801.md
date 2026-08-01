# FreeW Word 2013 repeating-section content controls

Date: 2026-08-01

## Scope

This functional-parity slice preserves the canonical Word 2013 structured-document-tag semantics for:

- `w15:repeatingSection`, including optional `w15:sectionTitle` and `w15:doNotAllowInsertDeleteSection` properties.
- `w15:repeatingSectionItem` children nested inside their owning repeating section.
- Required document-root `xmlns:w15`, `xmlns:mc`, and `mc:Ignorable="w15"` declarations whenever either role is emitted.

No editor, host, presentation, page-border, or UI behavior is changed.

## Model and package behavior

- `BlockContentControlKind` distinguishes repeating sections from repeating-section items.
- `BlockContentControl.Parent` retains the nested outer-section/item relationship while blocks remain ordinary model paragraphs or tables.
- Factory methods create a valid repeating section and reject an item whose parent is not a repeating section.
- The DOCX reader imports the two `w15` roles, section title, insertion/deletion restriction, IDs, tags, aliases, and shared item ownership.
- The DOCX writer reconstructs the nested SDT graph and canonicalizes a true insertion/deletion restriction as an empty on/off element.
- Ordinary block and inline content controls remain flat and do not cause Word 2013 namespace or markup-compatibility declarations.

## Evidence

The focused package test begins with a hand-authored Word 2013 document containing one outer section and two item SDTs. It asserts:

- Three imported blocks, with the first two sharing item identity and both item controls sharing one parent section identity.
- Exact section/item kinds and preserved title, lock semantic, IDs, tags, and aliases.
- One outer `w:sdt`, two nested item `w:sdt` elements, canonical child order, canonical empty true on/off form, and exact `w:val` title storage.
- Required `w15` and `mc` root declarations plus `mc:Ignorable` membership.
- Office 2013 schema validity through the Open XML SDK validator on both saved packages.
- The same model and package assertions after reopening and saving a second time.
- An ordinary block-rich-text plus inline-plain-text control document remains free of repeating-section markup and modern namespace declarations.

## Verification

- `dotnet test freew/FreeW.Core.Model.Tests/FreeW.Core.Model.Tests.csproj --configuration Release --filter FullyQualifiedName~RepeatingSectionContentControlModelTests`: 2/2 passed.
- `dotnet test freew/FreeW.Core.IO.Tests/FreeW.Core.IO.Tests.csproj --configuration Release --filter FullyQualifiedName~RepeatingSectionContentControlRoundTripTests`: 2/2 passed.
- `dotnet test freew/FreeW.Core.IO.Tests/FreeW.Core.IO.Tests.csproj --configuration Release --no-build --filter FullyQualifiedName~ContentControl`: 32/32 passed.
