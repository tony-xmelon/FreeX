# FreeP Linux File And Slideshow Shortcut Evidence - 2026-07-25

This document defines a dedicated, non-exhaustive physical X11 evidence lane for
FreeP Avalonia. It is intentionally separate from the family runner: the existing
FreeP family baseline keeps its exact 22-row contract, while this lane emits exactly
these ten unique result IDs:

- `visible-window-discovery`
- `file-new-shortcut-lifecycle`
- `file-open-shortcut-lifecycle`
- `file-save-shortcut-current-path`
- `file-save-as-shortcut-lifecycle`
- `print-shortcut-backstage-lifecycle`
- `slideshow-from-beginning-lifecycle`
- `slideshow-from-current-lifecycle`
- `find-shortcut-lifecycle`
- `replace-shortcut-lifecycle`

## Physical fixture and harness

The orchestrator starts one harness-owned generic FreeP container through
`tools/Run-LinuxInteractiveDocker.ps1 -DocumentPath` using
`tools/FreeP.RenderCompare/corpus/21-comments-notes.pptx` (two slides). Defaults
are a unique lane port of `6092`, `1280x820`, and `96` DPI; all are configurable
on `tools/Run-FreePFileSlideshowShortcutValidation.ps1`. The runner stops only
the exact owned container it started unless `-KeepContainer` is supplied.

The probe first proves the visible, focused FreeP owner and the fixture filename in
the X11 title. It then uses physical X11 chords and pointer input for the file,
backstage, slideshow, and Find/Replace routes. `wmctrl -l` is the authoritative
top-level lifecycle inventory; Avalonia child-window IDs from `xdotool search` remain
diagnostic evidence. Dialog evidence retains before/open/focused/dismissed screenshots,
both inventories, reported active/focus IDs, titles, and WM_CLASS output.

## Evidence boundaries

- Ctrl+N is exercised after a real pointer-created slide mutation. Escape must remove
  the dirty prompt while preserving the dirty owner state and exact owner focus.
- Ctrl+O and Ctrl+Shift+S must discover a distinct `wmctrl` top-level native picker
  surface and restore the exact owner after Escape. The probe records reported
  active/focus IDs, the window-manager title, and child-window counts, but does not
  gate on them because native portals can expose the application title and nested
  X11 child windows inflate global counts.
- Ctrl+S is exercised on a physically dirtied current-path presentation. The probe
  retains mounted-document SHA256 before/after files; the runner also retains source
  fixture before/after and host-mounted-after SHA256 evidence. A Save As window is
  explicitly disallowed for this row.
- Ctrl+P must change the in-window `FreePBackstageOverlay` Print surface while the
  owner window remains active, then restore the owner after Escape.
- Slideshow proof selects slide 2 by pointer and runs three calibrated captures:
  Shift+F5 from slide 1 as the slide-1 control, Shift+F5 from slide 2, and F5 from
  slide 2. Each candidate-window capture must contain non-black rendered slide
  content; the F5 stage must match the slide-1 control within a small `AE <= 1000`
  capture tolerance and differ materially from the slide-2 capture. Thumbnail, status,
  owner-window, slideshow window, and dismissal evidence remain attached to both rows.
- Ctrl+F and Ctrl+H must open distinct visible Find/Replace modes. Each route keeps
  the dialog's natural focused Find input, types its own sentinel with retry/settling,
  uses Ctrl+A/C, and proves exact X11 clipboard text before Escape restores the owner.
  The distinct titled `wmctrl` top-level window is the mode/lifecycle proof. Openbox can
  continue reporting the owner through `_NET_ACTIVE_WINDOW` and X11 focus while the
  naturally focused Avalonia textbox receives input, so those reported IDs are retained
  as diagnostics rather than pass/fail gates.

The lane is physical evidence for these named workflows only. It does not claim
exhaustive shortcut, dialog, file-format, slideshow, rendering, or parity coverage.
The new JSON schema is a structural reference; strict ten-row and artifact checks
remain owned by the dedicated PowerShell runner rather than a general JSON Schema
engine.

## Static verification

No Docker or physical pass is run in this change. The intended review checks are:

```powershell
$tokens = $null; $errors = $null
[System.Management.Automation.Language.Parser]::ParseFile(
  (Resolve-Path tools/Run-FreePFileSlideshowShortcutValidation.ps1),
  [ref]$tokens, [ref]$errors) | Out-Null
```

```text
"C:\Program Files\Git\bin\bash.exe" -n tools/LinuxInteractiveDocker/run-freep-file-slideshow-shortcut-probe.sh
```
