# FreeW decorative page border package parity (2026-08-01)

## Scope

FreeW modeled decorative page borders as Word `WdPageBorderArt` numeric ids, but wrote those ids to a
non-schema `w:art` attribute while leaving every edge at `w:val="single"`. WordprocessingML stores the
decorative design directly in `w:val`, so Word received a solid border instead of the chosen artwork.

The shared model now maps the 17 styles exposed by FreeW's page-border gallery from their Word COM ids
to canonical WordprocessingML tokens. The gallery labels were corrected to the actual Word designs;
for example id 84 is People, id 38 is Flowers - Roses, and id 2 is Maple Muffins. The writer emits the
canonical token and no `w:art` attribute. The reader recovers the curated id from canonical Word files
and retains a compatibility fallback for older FreeW packages that contain the legacy attribute.

This is package and authoring parity. WPF and Avalonia still use their documented plain-line visual
fallback for decorative image tiles; that renderer work remains a separate slice.

## Word Reference

An isolated visible Word COM instance created a one-page Apples border with `ArtStyle=1` and
`ArtWidth=24`, saved through the short path `C:\FWA\word-apple.docx`, and quit cleanly.

- Word-authored DOCX SHA-256: `2806B94C542BFF094552E5808B3770CD9AF2644BD7C2E67A3655222377F7740F`
- Canonical edge payload: `w:val="apples" w:sz="24" w:space="24" w:color="auto"`
- Canonical package contains no `w:art` attribute.

This matches Microsoft's WordprocessingML page-border example, which places the art design in
`w:val`, and the documented Word `WdPageBorderArt` numeric constants:

- [BottomBorder WordprocessingML example](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.wordprocessing.bottomborder)
- [Word enumerated constants](https://learn.microsoft.com/en-us/previous-versions/office/developer/office-2003/aa211923(v=office.11))

## Verification

- `DesignDepthModelTests`: 24/24
- `DesignDepthRoundTripTests`: 14/14
- Focused Borders and Shading / Page Borders planner tests: 2/2
- Explicit XML assertions cover all four canonical `people` edges, `sz=24`, `space=24`, and absence
  of the legacy attribute.
- Reopened-model assertions cover curated ids 1, 38, 84, and 160.
- A legacy-package mutation proves old FreeW `w:art="84"` content still reopens as ArtId 84.

## Process Rule

For Office package semantics, compare the source XML from an application-authored file before adding
an extension attribute. Acceptance requires canonical serialized XML, the reopened model, and a
compatibility decision for already-written product payloads; an in-memory round trip alone is not
enough.
