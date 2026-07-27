# FreeW Header/Footer Prompt Parity Wave 38

Date: 2026-07-27
Authority: WPF `FreeW.App.Host/Ribbon/FreeWRibbonCommands.cs` and the shared
`HeaderFooterDialogPlanner`.

## Closed functional gap

The WPF Insert > Header and Insert > Footer commands prompt for text, seed the
prompt from the existing slot, preserve an existing PAGE field, and leave the
model unchanged on Cancel. Avalonia previously only created an empty page-margin
region. Its production `MainWindow` now opens an owner-modal `HeaderFooterTextDialog`
and applies accepted text through the same shared planner. Empty accepted text
clears a slot unless it contains a PAGE field; Cancel is a no-op.

The no-callback Avalonia registry fallback remains deterministic for headless
callers: it retains the prior undoable region-creation behavior. The real shell
always supplies the prompt callback.

## Verification

- Shared `HeaderFooterDialogPlannerTests`: 16/16.
- WPF authority `InsertHeaderFooter_UsesWpfPromptSeedAndCancelContract`: 1/1.
- WPF `FreeWRibbonParityTests`: 104/104.
- Avalonia production `Production_MainWindow_top_level_header_footer_uses_prompt_apply_and_cancel`: 1/1.
- Avalonia `HeaderFooterContextualTabTests` plus `InsertTabDepthTests`: 22/22.

## Residuals

This slice closes the functional command-route gap. It does not claim pixel-
identical WPF/Avalonia dialog chrome or native text rasterization. The existing
contextual Header & Footer Design editing surface remains a separate route and
is unchanged by this slice.
