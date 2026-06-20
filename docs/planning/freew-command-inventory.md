# FreeW Microsoft Word Command Inventory

Last updated: 2026-06-21

Current note: this inventory remains the broad Microsoft Word command-prioritization source. For
current FreeW runtime icon coverage, use [../icon-audit/freew-icon-audit-2026-06-19.md](../icon-audit/freew-icon-audit-2026-06-19.md),
which audited 169 commands, 168 local FreeW SVG assets, 390 linked shared SVGs, 119 OK rows, 50
Review rows, and 0 Inconsistent rows.

## Sources And Scope

- Primary command source: Microsoft Office Fluent UI command identifiers, `Microsoft 365/Current Channel/wordcontrols.xlsx` from [OfficeDev/office-fluent-ui-command-identifiers](https://github.com/OfficeDev/office-fluent-ui-command-identifiers/tree/main/Microsoft%20365/Current%20Channel).
- Ribbon/access-key sanity source: [Microsoft Support: Keyboard shortcuts in Word](https://support.microsoft.com/en-us/accessibility/word/keyboard-shortcuts-in-word), which names the default Word tabs and common command families.
- Counts below are raw workbook rows. The Microsoft workbook includes parent group rows, duplicate command anchors, contextual tabs, context menus, and non-ribbon commands, so these counts are prioritization signals rather than exact visible-button totals.

## Primary Word Surface

| Word surface | Microsoft tab id | Raw rows | Main command groups |
|---|---|---:|---|
| Quick Access Toolbar | Quick Access Toolbar | 14 | AutoSave, New, Open, Save, Print, Spelling, Writing Assistance, Read Aloud, Undo/Redo |
| Home | `TabHome` | 171 | Clipboard, Font, Paragraph, Styles, Editing, Voice, Editor, sensitivity/protection, Copilot/add-ins |
| Insert | `TabInsert` | 197 | Pages, Tables, Illustrations, Add-ins, Links, Comments, Header/Footer, Text, Symbols, Barcode |
| Draw | `TabDrawInk` | 52 | Input mode, pens, eraser, lasso, ink conversion, ruler, replay |
| Design | `TabWordDesign` | 30 | Themes, style sets, colors, fonts, paragraph spacing, watermark, page color, page borders |
| Layout | `TabPageLayoutWord` | 98 | Page setup, paragraph layout, arrange/wrap/position/align objects |
| References | `TabReferences` | 47 | Table of contents, footnotes/endnotes, research, citations, captions, index, table of authorities, acronyms |
| Mailings | `TabMailings` | 51 | Envelopes/labels, start mail merge, fields, preview results, finish merge |
| Review | `TabReviewWord` | 111 | Proofing, speech, accessibility, language/translate, comments, tracking, changes, compare, protect, ink |
| View | `TabView` | 43 | Document views, modes, page movement, show/hide, zoom, window, macros, document properties |
| Developer | `TabDeveloper` | 35 | Code/macros, add-ins, content controls, XML mapping, protect, templates |

## Contextual And Object Surfaces

| Word surface | Microsoft tab id | Raw rows | Main command groups |
|---|---|---:|---|
| Header & Footer | `TabHeaderAndFooterToolsDesign` | 91 | Header/footer galleries, insert document info, navigation, options, position, close |
| Table Design | `TabTableToolsDesign` | 35 | Table style options, table styles, borders/shading, draw borders |
| Table Layout | `TabTableToolsLayout` | 63 | Select/properties, rows/columns, merge/split, alignment, cell size, sort/repeat headers/formula |
| Picture Format | `TabPictureToolsFormat` | 150 | corrections/color/transparency, styles/effects, alt text, arrange, crop/size |
| Drawing Format | `TabDrawingToolsFormat` | 160 | shapes/styles/text/WordArt, alt text, arrange, size |
| Text Box Format | `TabTextBoxToolsFormat` | 98 | text box styles, text direction, arrange, size |
| Chart Format | `TabChartToolsFormatNew` | 146 | current selection, insert shapes, styles, arrange, size |
| SmartArt Format | `TabSmartArtToolsFormat` | 146 | shapes, styles, text, arrange, size |
| Graphics Format | `TabGraphicsToolsFormat` | 126 | icons/SVG graphics styles, alt text, arrange, size |
| 3D Model Format | `Tab3DModelToolsFormat` | 60 | views, arrange, alt text, size |

## FreeW Current Ribbon Icon Map

All assets in this table live under `freew/FreeW.App.Host/Resources/CommandIconsSvg`. Reused assets are copied from FreeX into FreeW so the app is self-contained.

| FreeW command | Word idMso reference | Icon file | Status |
|---|---|---|---|
| Paste | `PasteMenu`, `Paste`, `PasteGallery` | `paste.svg` | Reused from FreeX |
| Cut | `Cut` | `cut.svg` | Reused from FreeX |
| Copy | `Copy` | `copy.svg` | Reused from FreeX |
| Format Painter | `FormatPainter` | `format-painter.svg` | Reused from FreeX |
| Font family | `Font` | shared fallback | Covered by shared icon fallback |
| Font size | `FontSize` | shared fallback | Covered by shared icon fallback |
| Bold | `Bold` | `bold.svg` | Reused from FreeX |
| Italic | `Italic` | `italic.svg` | Reused from FreeX |
| Underline | `UnderlineGallery` | `underline.svg` | Reused from FreeX |
| Grow Font | `FontSizeIncreaseWord` | `grow-font.svg` | Reused from FreeX |
| Shrink Font | `FontSizeDecreaseWord` | `shrink-font.svg` | Reused from FreeX |
| Bullets | `BulletsGalleryWord` | `bullets.svg` | Created for FreeW |
| Numbering | `NumberingGalleryWord` | `numbering.svg` | Created for FreeW |
| Align Left | `AlignLeft` | `align-left.svg` | Reused from FreeX |
| Center | `AlignCenter` | `center.svg` | Reused from FreeX |
| Align Right | `AlignRight` | `align-right.svg` | Reused from FreeX |
| Normal style | `QuickStylesGallery`, `ApplyStylesPane` | `normal.svg` | Created for FreeW |
| Heading 1 style | `Heading1Apply` | `heading-1.svg` | Created for FreeW |
| Title style | style gallery entry | `title.svg` | Created for FreeW |
| Cover Page | `CoverPageInsertGallery` | `cover-page.svg` | Created for FreeW |
| Blank Page | `BlankPageInsert` | `blank-page.svg` | Created for FreeW |
| Page Break | `PageBreakInsertWord` | `page-break.svg` | Created for FreeW |
| Table | `TableInsertGallery` | `table.svg` | Reused from FreeX |
| Picture | `PictureInsertFromFile` | `picture.svg` | Reused from FreeX |
| Shapes | `GalleryAllShapesAndCanvas` | `shapes.svg` | Reused from FreeX |
| Margins | `PageMarginsGallery` | `margins.svg` | Reused from FreeX |
| Orientation | `PageOrientationGallery` | `page-orientation.svg` | Reused from FreeX; mapped from `orientation` |
| Paper Size | `PageSizeGallery` | `paper-size.svg` | Reused from FreeX; mapped from `size` |

## First Word-Specific Icon Batch

Created now for likely next FreeW milestones:

| Command family | Icon files |
|---|---|
| Styles | `normal.svg`, `heading-1.svg`, `heading-2.svg`, `title.svg` |
| Lists and pages | `bullets.svg`, `numbering.svg`, `cover-page.svg`, `blank-page.svg`, `page-break.svg` |
| References | `table-of-contents.svg`, `footnote.svg`, `endnote.svg`, `citation.svg`, `bibliography.svg`, `caption.svg`, `index.svg` |
| Mailings | `envelopes.svg`, `labels.svg`, `mail-merge.svg` |
| Review | `track-changes.svg`, `accept-change.svg`, `reject-change.svg`, `word-count.svg` |

## Current FreeW Ribbon Icon Coverage

The 2026-06-18 ribbon icon pass covers every direct command id currently emitted by the WPF FreeW ribbon plus the smaller Avalonia FreeW shell: 148 unique `freew.*` command ids.

- SVGs are checked into `freew/FreeW.App.Host/Resources/CommandIconsSvg` under direct command slugs, for example `freew.accept-all` -> `accept-all.svg`.
- Reused FreeX artwork is copied into FreeW under the FreeW slug so the FreeW app remains self-contained.
- Word-specific commands that FreeX does not have now have FreeW SVGs in the same 32 px vector style, with crisp 22 px `-small.svg` variants for alignment and indentation rule-line icons.
- `Free.Shared.Ribbon.Wpf.RibbonIconFactory` now allows a host-supplied app-local artwork resolver; FreeW installs its SVG loader before falling back to shared geometry.
- `freew/FreeW.App.Host.Tests/RibbonCommandIconAssetTests.cs` guards command-id coverage, non-empty SVGs, `freew.` prefix stripping, and the shared renderer's preference for FreeW app-local SVG artwork.

## Next Icon Backlog

The items below are now covered for commands that exist on FreeW's current ribbon. They remain useful as future backlog categories when additional Microsoft Word contextual tabs, galleries, and non-ribbon command surfaces are added.

| Priority | Word area | Missing/new icons to add next | Reuse candidates already in FreeW/FreeX |
|---|---|---|---|
| P0 | Home paragraph | Multilevel List, Justify, Line and Paragraph Spacing, Shading, Sort, Show/Hide paragraph marks | `increase-indent.svg`, `decrease-indent.svg`, `borders.svg`, `sort.svg` from FreeX |
| P0 | Home font | Text Highlight Color, Font Color, Clear Formatting, Change Case, Subscript, Superscript, Strikethrough | `highlighter.svg`, `font-color.svg`, `clear.svg`, `strikethrough.svg` from FreeX |
| P1 | Insert | Header, Footer, Page Number, Text Box, Quick Parts, WordArt, Drop Cap, Date and Time, Object, Equation | `header-footer.svg`, `text-box.svg`, `date-time.svg`, `symbol.svg` from FreeX |
| P1 | Design/Layout | Themes, Watermark, Page Color, Page Borders, Columns, Breaks, Line Numbers, Hyphenation | `themes.svg`, `theme-colors.svg`, `theme-fonts.svg`, `theme-effects.svg`, `breaks.svg` from FreeX |
| P1 | References | Update Table, Next Footnote, Manage Sources, Bibliography Style, Cross-reference, Mark Entry | assets started above; `hyperlink.svg` can cover cross-reference until a dedicated icon exists |
| P2 | Mailings | Start Mail Merge variants, Select Recipients, Address Block, Greeting Line, Insert Merge Field, Preview Results, Finish Merge | assets started above |
| P2 | Review | Spelling, Editor, Thesaurus, Read Aloud, Translate, New/Delete/Previous/Next Comment, Compare, Restrict Editing | `spelling.svg`, `spell-check.svg`, `new-comment.svg`, `delete.svg`, `translate` shared fallback |
| P2 | View | Read Mode, Print Layout, Web Layout, Outline, Draft, Navigation Pane, Ruler, Gridlines, Zoom, Window commands | `ruler.svg`, `gridlines.svg`, `zoom.svg`, `new-window.svg`, `view-side-by-side.svg` from FreeX |
| P3 | Contextual tables/pictures/shapes | Table styles, row/column insert/delete, merge/split cells, crop, corrections, transparency, alt text, arrange, wrap text | `table.svg`, `crop.svg`, `alt-text.svg`, `bring-forward.svg`, `send-backward.svg`, `wrap-text.svg` from FreeX |

## Notes

- Do not copy FreeX `orientation.svg` for Word Layout > Orientation; in FreeX that icon represents text orientation. FreeW maps `orientation` to `page-orientation.svg`.
- Do not use FreeX `size.svg` for Word Layout > Size; in FreeX that icon represents object size. FreeW maps `size` to `paper-size.svg`.
- The FreeW renderer looks up SVGs by command id without the `freew.` prefix, then falls back to the shared ribbon icon geometry.
