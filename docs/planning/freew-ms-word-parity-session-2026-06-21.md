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
- Expand Backstage Save As file-type choices from the writable FreeW adapter catalog, with each row opening Save As preselected to that format.
- Add a Word-style Open > Recover Unsaved Documents command backed by FreeW's existing autosave recovery snapshots.
- Add a Word-style Account rail pane backed by local FreeW product, version, Windows user, device, and data-folder details.
- Add Word-style File > Info document-safety actions backed by FreeW's existing Mark as Final, Restrict Editing, Inspect Document, and Check Accessibility commands.
- Convert Backstage Print from an immediate command into a Word-style pane backed by FreeW's existing Print and Print Preview paths plus current document page setup details.
- Expand Backstage Export > Change File Type from a single Word Document row to the backed writable FreeW catalog: Word document/template variants, Word XML, web pages, MHTML, RTF, and plain-text formats.
- Add Word-style Recent Documents directly to the Backstage Open pane, backed by FreeW's existing local recent-files store and OpenPath flow.
- Add Word-style Backstage Share rail placement with FreeW's backed local subset: saved-file folder reveal, Save As when sharing is not ready, Save a Copy, and Create PDF/XPS.
- Add Word-style View > Show > Ruler as a stateful toggle over FreeW's existing passive page ruler chrome.

## Live Word Comparison Notes

Microsoft Word is installed at `C:\Program Files\Microsoft Office\Root\Office16\WINWORD.EXE`. Direct launch is reachable from this environment. A live Word 16.0 / build 16.0.20026 Backstage inspection on 2026-06-22 found this rail order: Home, New, Open, Share, Info, Save, Save As, Print, Export, Close, Account, Options.

Relevant Word Backstage details from that pass:

- Open is place-driven: Recent, shared/cloud locations, Quick access, This PC, Add a Place, Browse, plus a main pane with search, Documents/Folders tabs, recent documents, and Recover Unsaved Documents.
- Save As is place-driven: Recent, OneDrive, Quick access, share options, This PC, Add a Place, Browse, plus filename/type controls and a broad file-type dropdown.
- Export groups Publishing Features into Create PDF/XPS Document and Change File Type, with document-file and other-file-type choices.
- Home combines New and Open regions: Blank document and template tiles, More templates, Recent/Favorites/Shared with Me, search, and recent rows. FreeW now backs the local subset with Blank document, Browse, and Recent instead of adding nonfunctional cloud/search/template placeholders.
- New is a first-class template page in Word with Blank document, online template search, Office/tenant tabs, category chips, and template pins. FreeW now routes New to its backed Blank document template pane and leaves online/template catalog work in the backlog.
- Close is a main rail command in Word, above Account and Options, and closes the current document/window. FreeW now wires Close to the existing WPF window close path so the save-before-close prompt is preserved.
- Save As exposes a broad file-type picker in Word. FreeW now mirrors the backed subset from its writable adapter catalog: Word document/template variants, Word XML, web page/single-file web page, RTF, and plain-text formats; PDF/XPS remain in Export because those are backed by export actions rather than Save As adapters.
- Open exposes Recover Unsaved Documents. FreeW now surfaces a matching local command backed by its autosave recovery snapshot store; it does not add cloud or account places that are not backed locally.
- Account sits above Options in Word's Backstage rail. FreeW now exposes a backed local Account pane there with product/user/device/storage information and a link into the existing Options dialog, without fake Microsoft account or cloud sign-in surfaces.
- Info exposes document protection and inspection affordances in Word. FreeW now mirrors the backed local subset in File > Info: Protect Document actions for Mark as Final and Restrict Editing, plus Inspect Document actions for metadata/revision inspection and accessibility checks.
- Print is a Backstage page in Word, not just an immediate command. FreeW now opens a Print pane with backed Print and Print Preview actions and a summary of the current document's paper size, orientation, margins, and columns.
- Export > Change File Type lists multiple document types in Word. FreeW now mirrors its backed local subset from the writable adapter catalog instead of exposing only a hard-coded Word Document row.
- Open shows recently edited documents inside Word's Open page. FreeW now mirrors the local subset by showing recent documents directly in File > Open when the local recent-files store has entries, while retaining Browse and Recover Unsaved Documents.
- Share appears between Open and Info in Word's Backstage rail. FreeW now mirrors that placement with backed local actions: saved local documents can reveal their containing folder for sharing, unsaved or missing-path documents route to Save As first, and the pane also offers Save a Copy plus Create PDF/XPS without adding fake cloud sharing.
- View > Show includes a Ruler toggle in Word. FreeW now mirrors the backed subset by showing a Ruler command in the View > Show group, wired to the existing passive horizontal and vertical ruler chrome without claiming draggable ruler editing yet.

## Prioritized Parity Backlog

1. Decide whether Draw and Help should appear only after real backing commands exist, or with disabled explanatory affordances.
2. Improve Design with visible style-set/font/effects surfaces once those can be backed independently; Colors is now exposed through the existing theme palette model.
3. Add more Mailings surfaces only when backed: Envelopes/Labels, Address Block, Greeting Line, and Start Mail Merge variants.
4. Continue ruler parity beyond the visibility toggle: draggable indents or tab stops.
5. Continue Backstage parity beyond the local places slice: cloud/add-place affordances, and richer Save As inline filename/type controls.
6. Formalize rendered shell evidence using `freew/tools/FreeW.RibbonShot` and document the output manifest.

## Non-Goals For This Session

- Do not absorb the other feature-completion session's branch or worktree.
- Do not rewrite the document rendering engine for true editable pagination in this wave.
- Do not add placeholder commands that cannot execute or provide useful feedback.
