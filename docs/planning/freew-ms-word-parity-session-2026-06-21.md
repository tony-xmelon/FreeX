# FreeW MS Word Parity Session - 2026-06-21

## Scope

This session targets visible MS Word alignment in the WPF FreeW app, not the separate feature-completion branch. The work should prefer UI surfaces that expose already-implemented FreeW behavior before starting deeper document-model features.

Current implementation wave:

- Promote implemented reference tools to a top-level References tab.
- Add Home > Font > Strikethrough because the editor/model already preserve strikethrough formatting.
- Add Home > Editing with Find, Replace, and Select, reusing the existing Find & Replace dialog and WPF Select All.
- Normalize implemented top-level tabs to Word's visible flow: Home, Insert, Design, Layout, References, Mailings, Review, View.
- Expand Review > Comments with real Delete, Previous, and Next thread actions, matching Word's visible comment workflow.
- Split implemented table tools into Word-style contextual Table Design and Table Layout tabs, while keeping Insert focused on creating tables.
- Move implemented content controls to a Word-style Developer > Controls surface instead of Insert.
- Move Watermark into Design > Page Background with Page Color/Page Borders, and rename the Mailings entry point to Select Recipients.
- Make Design > Document Formatting expose a labelled, backed Colors surface beside Themes, and persist applied theme choices into the saved DOCX theme state.
- Surface the existing Save a Copy command in Word-style Backstage between Save As and Print.
- Convert Backstage Open and Save As from immediate rail commands into Word-style place panes for local browsing, and regroup Export into Create PDF/XPS Document plus Change File Type sections.
- Make Backstage Home the Word-style landing pane and promote New to the backed template pane, removing the duplicate New from template rail entry for FreeW.
- Move Backstage Close into the main Word-style rail order and wire it to the real dirty-gated window close path.

## Live Word Comparison Notes

Microsoft Word is installed at `C:\Program Files\Microsoft Office\Root\Office16\WINWORD.EXE`. Direct launch is reachable from this environment. A live Word 16.0 / build 16.0.20026 Backstage inspection on 2026-06-22 found this rail order: Home, New, Open, Share, Info, Save, Save As, Print, Export, Close, Account, Options.

Relevant Word Backstage details from that pass:

- Open is place-driven: Recent, shared/cloud locations, Quick access, This PC, Add a Place, Browse, plus a main pane with search, Documents/Folders tabs, recent documents, and Recover Unsaved Documents.
- Save As is place-driven: Recent, OneDrive, Quick access, share options, This PC, Add a Place, Browse, plus filename/type controls and a broad file-type dropdown.
- Export groups Publishing Features into Create PDF/XPS Document and Change File Type, with document-file and other-file-type choices.
- Home combines New and Open regions: Blank document and template tiles, More templates, Recent/Favorites/Shared with Me, search, and recent rows. FreeW now backs the local subset with Blank document, Browse, and Recent instead of adding nonfunctional cloud/search/template placeholders.
- New is a first-class template page in Word with Blank document, online template search, Office/tenant tabs, category chips, and template pins. FreeW now routes New to its backed Blank document template pane and leaves online/template catalog work in the backlog.
- Close is a main rail command in Word, above Account and Options, and closes the current document/window. FreeW now wires Close to the existing WPF window close path so the save-before-close prompt is preserved.

## Prioritized Parity Backlog

1. Decide whether Draw and Help should appear only after real backing commands exist, or with disabled explanatory affordances.
2. Improve Design with visible style-set/font/effects surfaces once those can be backed independently; Colors is now exposed through the existing theme palette model.
3. Add more Mailings surfaces only when backed: Envelopes/Labels, Address Block, Greeting Line, and Start Mail Merge variants.
4. Decide a first interactive ruler slice: draggable indents or tab stops.
5. Continue Backstage parity beyond the local places slice: Share/Account rail decisions, cloud/add-place affordances, Recover Unsaved Documents as an explicit command, richer Save As inline filename/type controls, and broader format choices when backed.
6. Formalize rendered shell evidence using `freew/tools/FreeW.RibbonShot` and document the output manifest.

## Non-Goals For This Session

- Do not absorb the other feature-completion session's branch or worktree.
- Do not rewrite the document rendering engine for true editable pagination in this wave.
- Do not add placeholder commands that cannot execute or provide useful feedback.
