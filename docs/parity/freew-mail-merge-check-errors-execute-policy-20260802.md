# FreeW mail merge Check for Errors execute policy

## Gap

FreeW treated **Complete the merge, pausing to report each error** as an abort policy: any detected error
prevented completion. It also displayed no-pause errors only in a modal summary.

Microsoft documents `MailMerge.Execute(Pause: true)` as performing the merge while pausing to display a
troubleshooting dialog when an error is found; `Pause: false` performs the merge and reports errors in a new
document: <https://learn.microsoft.com/en-us/office/vba/api/word.mailmerge.execute>.

## Result

The shared error-check result now exposes explicit completion, pause, and report-document policies:

- **Simulate and report** does not complete and opens the editable report document.
- **Complete and pause** reports each detected issue individually, in deterministic order, then completes.
- **Complete without pausing** completes immediately and opens the editable report document when errors exist.

WPF performs the per-error modal sequence before delegating to `FinishMergeCommand`. Avalonia defers its
engine completion until the shell has shown the same sequence, then calls `FinishMerge`; headless engine callers
retain the default immediate-completion behavior.

## Verification

- shared mail-merge planner contracts: 16/16;
- full `FreeW.App.Presentation.Tests`: 1,180/1,180;
- WPF Check for Errors command contracts: 5/5;
- focused Avalonia route/policy contracts: 4/4; and
- full Avalonia mailings engine lane: 29/29.

## Residual

FreeW reports deterministic validation issues rather than reproducing Word's exact native troubleshooting
dialog text. The merge result and error report are editable FreeW documents, not COM-owned Word windows.
