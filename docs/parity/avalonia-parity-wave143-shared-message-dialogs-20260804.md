# Wave 143 Shared Message Dialog Parity

The shared Avalonia warning and error dialog now carries the same severity distinction as the WPF message path. Warning and error calls render different severity badges, while the dialog exposes the selected `UserMessageIcon` to keep the semantic contract explicit.

The shared dialog also follows `ShellStrings` for default severity titles and the OK button. The OK button remains both default and cancel, retains the WPF-compatible access key and automation name, and the message body remains wrapping within the fixed dialog width.

Scope is limited to `Free.Shared.Shell.Avalonia`; existing FreeX, FreeW, and FreeP Avalonia consumers continue to use the shared `ShowWarningAsync` and `ShowErrorAsync` entry points. Native picker boundaries are unchanged.
