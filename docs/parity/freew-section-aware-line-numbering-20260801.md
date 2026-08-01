# FreeW section-aware line numbering

Date: 2026-08-01

## Result

FreeW now models Word's `w:restart="newSection"` line-number mode instead of flattening it to continuous numbering. DOCX read/write preserves the exact token, authored start value and count-by interval.

The shared visual planner accepts the section owning each physical line and the settings for every section. It keeps continuous sequences across section boundaries, restarts `newPage` sequences at page boundaries, and restarts `newSection` sequences at section boundaries even when a continuous section break leaves both sections on the same physical page. Paragraph-level suppression still consumes a sequence number without painting the glyph.

Avalonia live layout and direct PDF export now retain block-to-section ownership. WPF's live line-number adorner uses the same shared plan, and print preview selects the section-aware paginator when line-number settings differ between sections. Both ribbons and line-number option dialogs expose **Restart Each Section**.

## Evidence

- Exact DOCX package test requires `w:restart="newSection"` and verifies the reopened model.
- Shared planner tests cover same-page section restart and continuous numbering across a section boundary.
- Avalonia live and PDF tests require first-section start 4 followed by second-section start 9 on the same page.
- WPF ribbon parity verifies the backed command changes the model to `RestartEachSection`.
- Existing continuous, restart-each-page, suppression, gutter and PDF raster tests remain green.

## Residuals

- WPF print preview still estimates physical line slots from page height, as it did for the existing continuous and restart-each-page modes. Exact glyph registration remains a visual calibration concern rather than a package or sequence-semantics gap.
- The portable PDF text operation uses its built-in Helvetica face rather than Word's line-number style font.
