# FreeW/FreeP Linux Physical X11 Baseline

This slice adds a reusable, app-parameterized physical-input smoke runner for
the Avalonia FreeW and FreeP applications:

```powershell
powershell -File tools/Run-FamilyLinuxInteractionValidation.ps1 -App FreeW
powershell -File tools/Run-FamilyLinuxInteractionValidation.ps1 -App FreeP
```

The runner starts the existing harness on an isolated port, discovers the visible
application window, and retains a screenshot plus a machine-readable manifest for:

- the visible-window discovery;
- standalone `Alt` key-tip appearance and `Escape` dismissal;
- standalone `F10` key-tip appearance and `Escape` dismissal;
- switching a ribbon tab by key tip (`I` for FreeW, `N` for FreeP);
- opening and dismissing the app's File surface.

FreeW additionally runs an eighteen-row physical editing slice within the
exact forty-five-row contract (the prior thirty-seven-row baseline plus the
Wave 95 backstage/options extension): it clicks the real document editor, replaces
the selection with a sentinel, proves exact X11 clipboard text, proves Ctrl+Z and
Ctrl+Y restore the exact clipboard states, proves Ctrl+X followed by Ctrl+Z
restores the exact selected content, and exercises Ctrl+Shift+V with an exact
plain-text clipboard. The text-only route records that a plain-text X11
clipboard cannot distinguish rich-format stripping, so it does not claim that
semantic distinction. The slice also opens and dismisses Find and Replace as
separate keyboard routes, with Ctrl+F and Ctrl+H focusing different fields,
then opens and dismisses Reveal Formatting and Thesaurus through their shared
shortcuts. Finally it opens/dismisses the real editor context menu through both
Shift+F10 and a pointer right-click. After the undo-sensitive workflows finish,
it types `I teh ` through real X11 key events and requires the shared
AutoCorrect result `I the ` on the exact clipboard. These rows are intentionally
FreeW-only.

Before the sentinel edit makes the document dirty, FreeW runs four clean-document
file-shortcut lifecycles: Ctrl+O, Ctrl+S, Ctrl+Shift+S, and Ctrl+P. Each route
discovers the newly visible top-level X11 window relative to the owner window set,
retains title and WM_CLASS evidence, proves active focus and an increased window
count, captures the open/focused/dismissed transition, then uses Escape to prove
removal and exact owner restoration. Ctrl+S is the untitled-document Save As
route, not a current-path save. Ctrl+P uses the harness-owned CUPS dry-run
printer and proves the direct Print dialog shared with the WPF shortcut
contract, rather than the distinct Print Preview command. After the sentinel
and existing editor probes,
FreeW runs Ctrl+N twice on the dirty document. The first prompt is cancelled and
must preserve an exact clipboard sentinel; the second selects Don't save through
physical Tab/Return navigation and must leave a removed prompt, owner restoration,
a clean title, and a genuinely empty document proven by an unchanged unique
clipboard marker. Those twelve rows brought the prior FreeW contract from
twenty-five rows to exactly thirty-seven while keeping coverage non-exhaustive.
The required FreeW IDs are `file-open-shortcut-dialog-open`,
`file-open-shortcut-dialog-dismissal`, `file-save-shortcut-dialog-open`,
`file-save-shortcut-dialog-dismissal`, `file-save-as-shortcut-dialog-open`,
`file-save-as-shortcut-dialog-dismissal`, `file-print-shortcut-dialog-open`,
`file-print-shortcut-dialog-dismissal`, `file-new-shortcut-dirty-prompt-open`,
`file-new-shortcut-cancel-preserves`, and
`file-new-shortcut-discard-creates-clean`.
The Wave 95 extension adds eight FreeW-only real-input rows for the Backstage
Print and Export panes and the Options workflow. `backstage-print-open` and
`backstage-print-dismissal` navigate the real rail to Print and prove Escape
restores the owner. `backstage-export-open` and
`backstage-export-dismissal` cover the matching Export route. `options-open`
opens the real Options dialog through the Backstage Options pane;
`options-tab-navigation` uses physical Ctrl+Tab input, `options-focus` uses a
physical Tab input while requiring dialog focus, and `options-close` proves
Escape restores the original owner/window state. These rows bring the FreeW
manifest to exactly forty-five results; FreeP remains an exact twenty-four-row
contract.
FreeP first runs `nested-keytip-prefix-deferral`: physical `Alt,N,T,X` inserts
and selects a text box, then `Alt,A,N,B` must retain key-tip mode because
`Blinds In=BI` is still reachable even though `Blink=B` is an exact leaf.
The following `I` must open the Blinds menu, and `Escape` must dismiss it.
FreeP then proves the real Animation Pane open/select/close/reopen workflow as
`animation-pane-physical-workflow`, followed by a fourteen-row slide-pane slice
for an exact twenty-four-row contract: it clicks
the real bottom `+ New Slide` affordance, proves the changed thumbnail-pane
evidence, retains the calibrated main-view frame as contextual evidence, proves
that Ctrl+Z and Ctrl+Y restore the exact calibrated pre-create and created
states, and opens/dismisses the real slide-thumbnail context menu through
both Shift+F10 and a pointer right-click. The screenshot regions and calibration
artifact are retained with each physical run. From that proven two-slide,
first-selected state, the lane then selects slide 2 by pointer, returns to slide
1 with Up, duplicates to three slides with Ctrl+D, proves Ctrl+Z/Ctrl+Y, deletes
the selected slide, and proves Ctrl+Z restores the exact three-slide state.
Every later row is gated on its predecessor and retains calibrated thumbnail
and status crops. The required FreeP IDs are
`nested-keytip-prefix-deferral`, `slide-pane-new-slide-create`, `slide-pane-new-slide-undo`,
`slide-pane-new-slide-redo`, `slide-pane-keyboard-context-open`,
`slide-pane-keyboard-context-dismissal`, `slide-pane-pointer-context-open`, and
`slide-pane-pointer-context-dismissal`, followed by
`slide-pane-pointer-select-second`, `slide-pane-keyboard-up-first`,
`slide-pane-duplicate-create`, `slide-pane-duplicate-undo`,
`slide-pane-duplicate-redo`, `slide-pane-delete-selected`, and
`slide-pane-delete-undo`.

FreeW's File key tip is expected to open its separate top-level `BackstageView`
window. FreeP's File key tip is expected to open the in-window
`FreePBackstageOverlay`/`BackstageView` user control while retaining the owner
window and X11 window count. These distinct invariants are retained in the
manifest's `appSurface`, `parameters.fileSurface`, and result notes.

## Evidence contract

The probe writes `family-x11-results.json` and state screenshots under the session's
`family-validation/` directory. The manifest follows the contract described by
`tools/LinuxInteractiveDocker/family-x11-validation.schema.json`. The PowerShell
runner performs strict contract validation of the required header, app-specific
surface parameters, result IDs, summary counts, physical evidence level, and every
referenced artifact, including non-empty files. It records that result as
`contractValidation.status=passed`; this runner does not claim to execute a general
JSON Schema engine.

The `coverage.exhaustive` field is always `false`. This is a deterministic baseline,
not exhaustive command, dialog, context-menu, shortcut, or visual parity coverage.
The FreeW editing rows are physical evidence for the listed editor paths only,
not a claim that every editing command or every shortcut has been exercised.
FreeX remains covered by `tools/Run-FreeXLinuxInteractionValidation.ps1`; future
family work can extend this runner with additional parameterized probes without
copying the FreeX-specific calibration and grid workflow.

By default the host runner stops only the harness-owned container that it started.
Use `-KeepContainer` when retaining the desktop for interactive inspection; never
stop or replace a container that is not owned by this harness.
