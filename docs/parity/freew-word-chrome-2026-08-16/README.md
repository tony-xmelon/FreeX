# FreeW Word Chrome Reference Lane - 2026-08-16

## Purpose

This lane records native Microsoft Word ribbon chrome for the nine standard
top-level tabs that map to FreeW's standard profile: Home, Insert, Design,
Layout, References, Mailings, Review, View, and Help. Each state is captured
at 1280, 1100, 900, and 750 logical-window widths, with the top 300 logical
pixels captured after Word foreground ownership is validated.

The references are intentionally separate from FreeW's app-owned evidence.
FreeW now has 40 static and 32 contextual paired WPF/Avalonia whole-window
captures, plus the dialog harness and Word document-page baselines. Native
Word chrome is **not a raw pixel-equivalence claim** between Word and either
WPF or Avalonia: their window frames, title/QAT arrangements, and ribbon
implementations deliberately differ.

## Capture Contract

Run from the repository root on an unlocked interactive Windows desktop:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Capture-FreeWWordChrome.ps1
```

The tool starts its own blank Word document, checks that the Word process and
exact window title own the foreground before every tab selection and screen
capture, and stops only the Word PID it started. It retains either a complete
`manifest.json` with 36 PNGs or a `blocker-manifest.json`; it never retains
partial evidence.

The lane uses Word's standard profile. FreeW's configurable Developer tab,
contextual tabs, Backstage, dialogs, panes, document canvas, and non-client
decoration remain separate evidence scopes.

## Current Result

The current machine session has not yet produced a valid foreground-owned Word
window. The committed blocker manifest is therefore a capture-environment
status, not a FreeW parity result. Re-run after the interactive desktop is
available and no other Office foreground capture is active.

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-FreeWWordChromeEvidence.ps1 -Check
```
