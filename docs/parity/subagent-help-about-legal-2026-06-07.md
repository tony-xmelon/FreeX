# Help, About, Feedback, and Legal Parity Slice

## Findings addressed

- Help tab command sources already route Help Online, Feedback, and Check for Updates through `ExternalUrlLauncher.Open`, with owned warning messages for blocked schemes or failed browser launches.
- Help tab `Copy Diagnostics` now matches the neighboring Help commands with `AutomationInvokeButton`, stable `AutomationProperties.AutomationId`, explicit UIA name/help text, and the existing `DG` keytip.
- Help tab `About FreeX` now exposes explicit UIA help text in addition to its stable name, automation id, handler, and `AB` keytip.
- Legal Notices now gives each generated notice tab a stable UIA name/id/help text and gives the default/cancel Close button a stable automation id.

## Validated coverage

- `HelpCommandSourceTests` checks all surfaced Help commands for localized content, invariant command name, keytip, click handler, automation id, UIA name, and UIA help text.
- `MainWindowXamlKeyTipTests.Dialogs` checks Help/Feedback/Diagnostics/About/Legal entry points, stable automation ids, keytips, and honest help text.
- `LegalNoticeProviderTests` checks embedded offline legal resources, copyable read-only Legal Notices text, generated tab UIA metadata, and default/cancel Close behavior.
- Existing source coverage confirms About uses an owned message box and Legal Notices uses `ShowOwnedDialog`, while external Help/Feedback/Update launches use guarded browser-opening code.

## Remaining gaps

- No live foreground UIA pass was run in this slice, so browser launch allow/block behavior and native message-box focus return still need guarded live validation.
- About remains an owned `MessageBox` rather than a custom inspectable dialog; source coverage verifies ownership and text, but live close/focus proof is still pending.
- Legal Notices visual screenshots were not captured; this slice validated the generated WPF tree and source behavior only.
