# FreeW MS Word Parity Session - 2026-06-21

## Scope

This session targets visible MS Word alignment in the WPF FreeW app, not the separate feature-completion branch. The work should prefer UI surfaces that expose already-implemented FreeW behavior before starting deeper document-model features.

Current implementation wave:

- Promote implemented reference tools to a top-level References tab.
- Add Home > Font > Strikethrough because the editor/model already preserve strikethrough formatting.
- Add Home > Editing with Find, Replace, and Select, reusing the existing Find & Replace dialog and WPF Select All.
- Normalize implemented top-level tabs to Word's visible flow: Home, Insert, Design, Layout, References, Mailings, Review, View.
- Regroup the implemented Insert commands into Word-style command geography: Illustrations, Links, Header & Footer, Text, and Symbols.
- Expand Review > Comments with real Delete, Previous, and Next thread actions, matching Word's visible comment workflow.
- Regroup the backed Review tab into Word-style command geography by splitting Accessibility out from Inspect, keeping Tracking focused on Track Changes/Reviewing Pane, and moving Accept All/Reject All under Changes dropdowns.
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
- Add Word-style Design > Document Formatting > Style Sets as backed preset rewrites of FreeW's built-in style catalog, with live preview and DOCX style round-trip through `styles.xml`.
- Add Word-style Design > Document Formatting > Fonts as backed heading/body font-pair presets that preserve the current colour palette and round-trip through the DOCX theme font scheme plus style catalog.
- Add Word-style Design > Document Formatting > Paragraph Spacing as backed spacing presets over FreeW's document default and built-in paragraph style catalog, with live preview and DOCX style round-trip through `styles.xml`.
- Continue Word-style View > Show > Ruler parity by making the horizontal ruler interactive for backed indent markers and simple left tab stops, including Word-style drag-off-ruler tab-stop removal, using FreeW's existing undoable paragraph formatting and tab-stop model paths.
- Expand Word-style Mailings with backed Start Mail Merge modes for Letters and Directory output, a Normal Word Document session reset, and a visible Edit Recipient List command over FreeW's existing CSV recipient dialog.

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
- View > Show includes a Ruler toggle in Word. FreeW now mirrors the backed subset by showing a Ruler command in the View > Show group and letting the horizontal ruler add, move, and remove simple left tab stops plus drag first-line, left, and right indent markers through existing paragraph formatting commands. Deeper Word ruler surfaces such as the tab selector, default tab interval editing, and vertical ruler editing remain out of scope.
- Design > Document Formatting includes Style Sets in Word. FreeW now mirrors the backed subset with Office, Simple, Elegant, and Formal presets that rewrite built-in paragraph styles while preserving style IDs and custom styles.
- Design > Document Formatting includes Effects in Word. FreeW now mirrors the backed subset with Office, Subtle, Moderate, and Intense effect-set presets that update the document theme's `a:fmtScheme`, round-trip through DOCX, and visibly affect FreeW-authored shapes, charts, SmartArt, and WordArt in the live editing surface with heavier object strokes plus Word-style shadow/soft-edge cues.
- Design > Document Formatting includes Fonts in Word. FreeW now mirrors the backed subset with Office, Cambria, Georgia, and Trebuchet heading/body font-pair presets that update built-in style inheritance while preserving current colours; custom font-pair authoring, script-specific font mappings, and font availability checks remain out of scope.
- Design > Document Formatting includes Paragraph Spacing in Word. FreeW now mirrors the backed subset with No Paragraph Space, Compact, Tight, Open, Relaxed, and Double presets that update document/default style paragraph spacing while preserving fonts, colours, style IDs, custom styles, and direct paragraph overrides.
- Mailings exposes Start Mail Merge and Edit Recipient List in Word. FreeW now mirrors the backed local subset by offering Letters output, Directory output, Normal Word Document reset, Select Recipients, and Edit Recipient List over the existing mail-merge session and CSV recipient dialog. E-mail messages, envelopes, labels, rules, Address Block, Greeting Line, and recipient filtering/sorting remain out of scope until backed by dedicated generation or field-matching behavior.
- Insert in Word groups creation commands by geography: Illustrations holds pictures, shapes, SmartArt, chart, and screenshot; Header & Footer holds header/footer/page-number; Text holds text box, Quick Parts, WordArt, Drop Cap, Date & Time, Object, Text from File, and fields; Symbols holds Equation and Symbol. FreeW now mirrors that backed subset while keeping selected-picture editing commands on the contextual Picture Format tab. Unbacked Word surfaces such as Online Pictures, Icons, 3D Models, Add-ins, Online Video, Comments, and Signature Line remain out of scope until they have local behavior.
- Review in Word separates Accessibility, Tracking, Changes, Compare, and Protect into distinct command regions. FreeW now mirrors the backed subset by moving Check Accessibility into its own Accessibility group, keeping Tracking to Track Changes and Reviewing Pane, and exposing Accept This/Accept All plus Reject This/Reject All through Changes dropdowns. Language/Translate, Editor-style cloud proofing, and ink remain out of scope until backed locally.
- Help in Word exposes product support, feedback, update, About, and legal surfaces. FreeW now mirrors the backed local subset with a FreeW-branded Help tab: guarded Help Online, Feedback, Copy Diagnostics, Check for Updates to the FreeW release workflow, About FreeW, and offline Legal Notices. Microsoft account sign-in, cloud training, Contact Support, and fake updater behavior remain out of scope.
- Draw in Word is centered on ink tools such as pens, eraser, lasso selection, and ink conversion. FreeW has backed drawing-object creation through Insert for pictures, shapes, text boxes, WordArt, SmartArt, charts, screenshots, equations, and OLE objects, but no backed ink model or pen/eraser/lasso commands yet. Keep those object commands in Insert/contextual tabs and do not add a top-level Draw tab until real ink behavior exists.

## Prioritized Parity Backlog

1. Keep Draw hidden until real ink backing exists; do not add placeholder pen, eraser, lasso, ink replay, ink-to-shape, or ink-to-math commands.
2. Add more Mailings surfaces only when backed: recipient filtering/sorting, Rules, Address Block/Greeting Line with robust field matching, E-mail Messages, Envelopes, and Labels.
3. Continue ruler parity beyond the backed horizontal subset: tab selector variants, default tab interval editing, and vertical ruler editing.
4. Continue Backstage parity beyond the local places slice: cloud/add-place affordances, and richer Save As inline filename/type controls.
5. Formalize rendered shell evidence using `freew/tools/FreeW.RibbonShot` and document the output manifest.

## Non-Goals For This Session

- Do not absorb the other feature-completion session's branch or worktree.
- Do not rewrite the document rendering engine for true editable pagination in this wave.
- Do not add placeholder commands that cannot execute or provide useful feedback.
