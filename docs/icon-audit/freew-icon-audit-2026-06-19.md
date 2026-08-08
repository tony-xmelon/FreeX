# FreeW Ribbon Icon Audit

Generated: 2026-06-19

<!-- VERIFY: SVG asset counts below are ~7 weeks stale as of this audit (2026-08-08). The generator
     (`tools/icon-audit/generate-freew-icon-audit.mjs`) still points at the correct current directories
     (`freew/FreeW.App.Host/Resources/CommandIconsSvg` for local, `src/FreeX.Ribbon.Definitions/Resources/CommandIconsSvg`
     for shared — paths are current, not stale from the shared-tier extraction), but a raw file count now
     shows 547 SVGs under the FreeW local directory versus the "168" reported here — FreeW's icon set has
     grown substantially since this audit ran. Regenerate via the script rather than trusting this count. -->

## Summary

- Commands audited: 169
- FreeW local SVG assets inventoried in HTML: 168
- Linked FreeX shared SVG assets inventoried in HTML: 390
- OK: 119
- Review: 50
- Inconsistent: 0
- Commands resolving through FreeW local SVGs: 97
- Commands resolving through linked FreeX shared SVGs: 72
- Avalonia-only command rows: 6
- Duplicate local/shared SVG file names: 0
- Empty local SVG shells: 0

## Main Findings

- FreeW has complete direct SVG coverage for the visible WPF/Avalonia command surface audited here; no missing runtime command SVGs were found.
- The local FreeW SVG set is cleanly separated from linked FreeX artwork: no duplicate local/shared file names were found.
- The strongest icons are the Word-specific References, Review, Insert, and page/document concepts that live in FreeW's local SVG folder.
- The main polish backlog is semantic specificity: several commands intentionally reuse broad shared artwork or nearby Word artwork, such as style management, image alignment, mail-merge variants, and table row/column actions.
- This audit is static and semantic; pair it with a rendered FreeW ribbon screenshot pass before closing a visual polish milestone.

## Suggested First Pass

1. Redraw the Styles group as a set: style picker, Normal, Heading, Title, New Style, and Manage Styles should read as a coherent Word style gallery.
2. Redraw table row/column insert/delete/header/banded/repeat/formula icons so each action is unmistakable at 20px.
3. Split mail-merge icons into data source, field, preview results, and finish/merge cues instead of a repeated mail-merge mark.
4. Create image-specific align/size/alt-text icons instead of leaning on text alignment and generic sizing metaphors.
5. Add a rendered FreeW ribbon visual validation lane mirroring the FreeX screenshot evidence once the app host can run reliably in this branch.

Regenerate local HTML/JSON tables from the audit tooling when a sortable command table or machine-readable inventory is needed; those generated files are ignored and should not be committed.

## Inconsistent Rows

| Tab | Group | Command | Runtime source | Suggested action |
| --- | --- | --- | --- | --- |

## Review Rows

| Tab | Group | Command | Runtime source | Suggested action |
| --- | --- | --- | --- | --- |
| Home | Font | All Caps | FreeW local | Create an all-caps-specific glyph; the current local asset is usable but close to generic typography. |
| Home | Font | Font | FreeX shared | Consider a distinct font-family cue rather than the shared Fonts artwork also used by font-size. |
| Home | Font | Size | FreeX shared | Consider a size-specific typography cue rather than the shared Fonts artwork also used by font-family. |
| Home | Font | Small Caps | FreeW local | Create a small-caps-specific glyph; the current local asset is usable but close to generic typography. |
| Home | Paragraph | Keep Lines Together | FreeW local | Use a page/paragraph keep-lines-together cue; current artwork is serviceable but abstract. |
| Home | Paragraph | Keep with Next | FreeW local | Use a page/paragraph keep-together cue; current artwork is serviceable but abstract. |
| Home | Paragraph | Paragraph Settings | FreeW local | Use a dialog-launcher/paragraph-settings cue rather than line-spacing artwork. |
| Home | Paragraph | Widow/Orphan Control | FreeW local | Use a widow/orphan page-flow cue; current artwork is serviceable but abstract. |
| Home | Styles | Manage Styles | FreeX shared | Use a styles pane/manager cue instead of broad styles artwork. |
| Home | Styles | New Style | FreeW local | Use a style tile plus add mark instead of a broad insert/document cue. |
| Home | Styles | Style | FreeX shared | Differentiate the style picker from individual style tiles; it currently resolves to shared styles.svg. |
| Home | Styles | Heading 1 | FreeW local | Give Heading 1 a stronger heading-preview cue distinct from Heading 2 and Title. |
| Home | Styles | Normal | FreeX shared | Give Normal a document-style preview cue rather than shared normal.svg. |
| Home | Styles | Title | FreeW local | Give Title a stronger title-preview cue distinct from Heading styles. |
| Insert | Illustrations | Align Center | FreeX shared | Prefer image-plus-text-wrap alignment cue over plain text alignment. |
| Insert | Illustrations | Align Left | FreeX shared | Prefer image-plus-text-wrap alignment cue over plain text alignment. |
| Insert | Illustrations | Align Right | FreeX shared | Prefer image-plus-text-wrap alignment cue over plain text alignment. |
| Insert | Illustrations | Alt Text | FreeX shared | Prefer picture plus text/alt badge over generic alt-text artwork. |
| Insert | Illustrations | Image Size | FreeX shared | Prefer a picture-resize cue over the shared generic size artwork. |
| Insert | Links | ScreenTip | FreeX shared | Use ScreenTip/tooltip artwork instead of comment-note artwork. |
| Insert | Links | Link to Bookmark | FreeX shared | Use a bookmark plus link cue instead of plain hyperlink artwork. |
| Insert | Links | Remove Hyperlink | FreeX shared | Use a broken/removed link cue instead of plain hyperlink artwork. |
| Insert | Media | Object | FreeX shared | Use embedded-object/OLE cue instead of broad insert artwork. |
| Insert | Quick Parts | Text from File | FreeX shared | Use text-from-file/document-insert artwork instead of broad insert artwork. |
| Insert | Quick Parts | Insert Quick Part | FreeX shared | Use quick-parts gallery artwork instead of broad insert artwork. |
| Insert | Quick Parts | Save Selection | FreeX shared | Use quick-parts plus save artwork instead of plain save artwork. |
| Insert | References | Citation Style | FreeW local | Use a citation-style dropdown cue distinct from Insert Citation. |
| Insert | References | Mark Entry | FreeW local | Use mark-entry cue distinct from Insert Index. |
| Insert | References | Update TOC | FreeX shared | Use table-of-contents plus refresh cue instead of generic refresh-all artwork. |
| Insert | References | Update Figures | FreeX shared | Use table-of-figures plus refresh cue instead of generic refresh-all artwork. |
| Insert | Table Tools | Banded Rows | FreeW local | Make banded rows visually distinct from generic table artwork. |
| Insert | Table Tools | Delete Column | FreeW local | Make column deletion more explicit with a highlighted deleted column. |
| Insert | Table Tools | Delete Row | FreeW local | Make row deletion more explicit with a highlighted deleted row. |
| Insert | Table Tools | Formula | FreeW local | Use a table-cell formula cue rather than a plain Sigma/total metaphor. |
| Insert | Table Tools | Header Row | FreeW local | Make the header-row state visually distinct from generic table artwork. |
| Insert | Table Tools | Insert Column | FreeW local | Make column insertion more explicit with a highlighted inserted column. |
| Insert | Table Tools | Insert Row | FreeW local | Make row insertion more explicit with a highlighted inserted row. |
| Insert | Table Tools | Repeat Header | FreeW local | Show repeated header/page continuation more explicitly. |
| Layout | Data | Table to Text | FreeW local | Use conversion arrows between table and text. |
| Layout | Data | Text to Table | FreeW local | Use conversion arrows between text and table. |
| Layout | Page Setup | Different First Page | FreeW local | Use first-page header/footer cue instead of cover-page artwork. |
| Layout | Page Setup | Vertical Align | FreeX shared | Use vertical page alignment cue instead of shared middle-align artwork. |
| Layout | Preview | Print Preview | FreeX shared | Use page-preview/magnifier cue instead of plain print artwork. |
| Mailings | Finish | Finish & Merge | FreeW local | Use finish-and-merge artwork distinct from the generic mail-merge mark. |
| Mailings | Preview Results | Preview Results | FreeW local | Use preview-results artwork distinct from the generic mail-merge mark. |
| Mailings | Start Mail Merge | Set Data | FreeW local | Use recipient/data-source artwork distinct from the generic mail-merge mark. |
| Mailings | Write & Insert Fields | Insert Merge Field | FreeW local | Use field placeholder artwork distinct from the generic mail-merge mark. |
| Review | Comments | Reply | FreeW local | Use reply arrow/comment cue distinct from New Comment. |
| Review | Comments | Resolve | FreeX shared | Use resolved-comment check cue distinct from Accept Change. |
| Review | Inspect | Inspect Document | FreeW local | Use document-inspector cue distinct from generic search. |
