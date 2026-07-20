# FreeP Native Picker Human Evidence

Native Open and Save As pickers are OS-owned surfaces. WPF uses native Windows dialogs; Avalonia uses the platform storage provider. Their pixels are intentionally not compared.

## Open

Run each check in both WPF and Avalonia:

- [ ] Cancel leaves the current presentation, path, and dirty state unchanged.
- [ ] PPTX and FXP choices are available; unsupported input is rejected by the application workflow.
- [ ] Missing, unreadable, or invalid input reports an error without replacing the current presentation.
- [ ] Focus returns to the owning FreeP window after cancel or error.

## Save As

Run each check in both WPF and Avalonia:

- [ ] Cancel preserves the current path and dirty state.
- [ ] The chosen PPTX or FXP extension controls the saved format; a missing extension follows the selected filter/default.
- [ ] Existing-file overwrite requires native confirmation; declining it leaves file and document state unchanged.
- [ ] Write or permission failure is reported without clearing dirty state or claiming success.
- [ ] Focus returns to the owning FreeP window after cancel, declined overwrite, or error.

Statuses remain `manual-required` until a human records host, Windows build, result, and evidence reference in the JSON manifest. This checklist is the explicit native-picker limitation; it is separate from the 28 app-owned paired visual scenarios.
