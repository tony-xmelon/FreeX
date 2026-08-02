# FreeW hidden-text Font dialog authoring

## Scope

FreeW already preserves WordprocessingML `w:vanish` and suppresses hidden text in WPF,
Avalonia, and PDF output. This slice makes Word's **Hidden** Font effect authorable in
both desktop hosts.

- The shared `FontDialogPlanner` projects and applies `RunFormatting.Hidden`.
- WPF exposes **Hidden** and applies it through the existing exact selected-run snapshot.
- Avalonia exposes a tri-state **Hidden** check box, reports mixed hidden/visible
  selections, and applies the toggle inside the existing Font undo group.
- `RunFormatting.WebHidden` remains independent and is not changed by the Font dialog;
  it continues to affect web layout only.

## Verification

- `FontDialogPlannerTests`: 27/27 passed.
- Focused WPF dialog/application tests: 3/3 passed.
- Focused Avalonia dialog/application tests: 16/16 passed.
- DOCX hidden and web-hidden round-trip tests: 21/21 passed.
- WPF dialog, formatting, and hidden/web-hidden live-layout tests: 21/21 passed.
- Avalonia dialog plus hidden/web-hidden live/PDF tests: 37/37 passed.
- `git diff --check`: clean.

The focused host commands built Release artifacts. Adjacent host gates used those exact
artifacts with `--no-build`.
