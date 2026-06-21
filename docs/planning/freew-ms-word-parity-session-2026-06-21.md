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

## Live Word Comparison Notes

Microsoft Word is installed at `C:\Program Files\Microsoft Office\Root\Office16\WINWORD.EXE`. Direct launch is reachable from this environment, but UI Automation exposed only a sparse start-window tree during this pass (`Help`, `File`, and `Home` names were visible). Use RibbonShot/visual capture for FreeW and manual or richer UIA/Office inspection for future Word shell evidence.

## Prioritized Parity Backlog

1. Decide whether Draw and Help should appear only after real backing commands exist, or with disabled explanatory affordances.
2. Improve Design with visible style-set/theme color/font/effects surfaces; the smallest backed slice is adding Watermark to Design > Page Background.
3. Bring Mailings names closer to Word: Select Recipients, Insert Merge Field, Preview Results, Finish & Merge, plus Envelopes/Labels if implemented.
4. Decide a first interactive ruler slice: draggable indents or tab stops.
5. Improve Backstage Save a Copy/export presentation.
6. Formalize rendered shell evidence using `freew/tools/FreeW.RibbonShot` and document the output manifest.

## Non-Goals For This Session

- Do not absorb the other feature-completion session's branch or worktree.
- Do not rewrite the document rendering engine for true editable pagination in this wave.
- Do not add placeholder commands that cannot execute or provide useful feedback.
