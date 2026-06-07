# macOS Accessibility Evidence Plan

**Last updated:** 2026-06-08

This plan turns the macOS/Avalonia accessibility validation gap into a concrete evidence lane. It applies to `src/FreeX.App.Avalonia` preview artifacts and complements the Windows accessibility gate in `docs/release/test-distribution.md`.

## Evidence Split

### Hosted checks

GitHub-hosted macOS runners can prove deterministic prerequisites for each `osx-arm64` and `osx-x64` artifact:

- the app bundle builds, packages, signs, notarizes when secrets are configured, staples when accepted, and records checksum evidence;
- LaunchServices can register and launch `FreeX.app` by bundle id and with workbook-file activation;
- the packaged app exposes expected native menu, toolbar, sheet-tab, status, clipboard, dialog, and workbook smoke markers in `freex-<runtime>-macos-evidence.txt`;
- static readiness checks keep Avalonia source wiring, bundle metadata, workflow markers, and portable-source hygiene aligned with the macOS preview contract.

Hosted evidence is necessary but not sufficient for public preview. It does not replace live VoiceOver behavior, real keyboard-only traversal, Finder/Gatekeeper prompts, or a human review of confusing announcements and focus traps.

### Human macOS validation

A human tester on macOS must record candidate evidence for:

- keyboard-only operation across launch, workbook open/save, grid navigation and editing, toolbar/menu commands, formula box edits, dialogs, sheet tabs, context menus, Help, and Quit/close dirty-workbook confirmation;
- VoiceOver smoke coverage for first launch, window title, workbook grid focus, visible cells, selected objects, formula box, status text, dialogs, warning messages, sheet tabs, and compact find/replace/go-to/format cells flows that are present in the candidate;
- Finder open and Open With behavior for `.fxl` and representative spreadsheet files, including any Gatekeeper prompt wording for the signing mode under test;
- known accessibility issues, including affected workflow, severity, workaround, owner, and whether the issue blocks public preview.

Record the macOS version, processor family, artifact runtime, workflow run id, run attempt, evidence file name, signing mode, notarization status, and tester notes with the release record.

## Initial Controls And Surfaces

The first macOS/Avalonia accessibility pass should cover these surfaces before widening scope:

- app shell: main window, native File/Edit/Format/View/Sheet/Help menus, toolbar commands, status surface, About, Legal Notices, and update/feedback/help links;
- workbook grid: active-cell focus, visible cell names/values, selection movement, edit entry, formula box commit/cancel, row/column headings, zoom, gridlines/headings toggles, freeze panes, and drawing-object selection names/status;
- workbook files: startup-argument open, Finder/Open With activation, in-app Open/Save/Save As, dirty close/quit confirmation, recent files, checksum verification, and ad-hoc versus Developer ID/Gatekeeper behavior;
- sheet navigation: sheet tabs, add/rename/move/hide/unhide/delete flows, grouped-sheet state, context-menu entry, F6 cycle, and keyboard tab switching;
- compact dialogs and menus currently in the preview app: Find, Find Next, Replace, Go To, Go To Special, Format Cells, Paste Special routes, color/border/style menus, and warning/confirmation dialogs.

## Public-Preview Blockers

Do not call a macOS artifact public-preview eligible until all of these are true:

- hosted evidence exists for both `osx-arm64` and `osx-x64`, including packaging, launch, checksum, signing/notarization, and LaunchServices smoke results;
- external distribution evidence shows `codesign_mode=developer-id`, `notarization_status=accepted`, and `stapler_validated=true`;
- the human keyboard-only pass is complete on real macOS hardware for the initial controls and surfaces above;
- the human VoiceOver pass is complete on real macOS hardware for the candidate app flows above;
- known accessibility issues are reviewed, listed in the release record, and either fixed or explicitly accepted as non-blocking for public preview;
- no candidate workflow has an untriaged focus trap, unreachable command, missing accessible name for a primary control, misleading VoiceOver announcement for a destructive action, or Gatekeeper/accessibility prompt that testers cannot follow.

If any item is missing or failed, treat the artifact as internal-only and keep the release notes clear that macOS accessibility evidence is incomplete.
