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
- Existing source coverage confirms About uses an owned `AboutDialog`, Legal Notices uses `ShowOwnedDialog`, and external Help/Feedback/Update launches use guarded browser-opening code.
- 2026-06-10 visual closure: `FREEX_HELP_ABOUT_LEGAL_TOUR=1` with `FREEX_SS_TOUR_ALLOW_BACKGROUND_RENDER=1` now emits committed deterministic FreeX evidence under `screenshots/help-about-legal-tour/`: Help ribbon context, owned guarded Help Online/Feedback/Updates warnings, About FreeX, Legal Notices tabs/Close surface, and Help focus-return/Ready-status proof after owned dialogs close.

## Remaining gaps

- No live foreground UIA pass was run in this slice, so mouse/keytip/UIA invoke, keyboard-close, and foreground-owned focus behavior still need guarded live validation.
- Browser launch allow-path behavior remains guarded separately; the committed tour intentionally captures owned blocked messages and records `ExternalBrowserLaunched=false`.
- No Microsoft Excel counterpart capture is produced by the FreeX tour; Excel About/license comparison remains a separate paired-evidence task where an exact equivalent exists.
