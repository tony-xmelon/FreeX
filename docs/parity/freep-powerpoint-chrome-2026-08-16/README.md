# FreeP PowerPoint Chrome Reference Lane - 2026-08-16

## Purpose

This lane records native Microsoft PowerPoint ribbon chrome for the seven
top-level tabs that map to FreeP's current shared profile: Home, Insert,
Design, Transitions, Animations, Slide Show, and View.  Each reference state
is captured at 1280, 1100, 900, and 750 logical-window widths, with the
top 300 logical pixels captured after PowerPoint foreground ownership is
validated.

The references are intentionally separate from FreeP's app-owned full-client
evidence.  FreeP already has 33 paired WPF/Avalonia full-client states in
`freep-whole-window-visual-evidence`, including title bar, QAT, ribbon,
Backstage, workspace, panes, notes, and status bar.  The native PowerPoint
captures add external chrome references; they are **not a raw pixel-equivalence
claim** between PowerPoint and either WPF or Avalonia.

## Uniform App-Owned Coverage

The existing paired app matrix covers the same 33 scenario ids on WPF and
Avalonia at a normalized 1280x760 logical client.  It includes six static
ribbon tabs (Home, Insert, Design, Transitions, Animations, View), seven
Backstage panes, title/QAT/status chrome, four view states, three workspace
regions, two rich-editor overlays, and eight auxiliary panes.  It currently
records 32 local WPF/Avalonia passes and one explicit rich-text-selection
mismatch.  The static tab set is the subset common to both FreeP hosts; FreeP
does not currently declare contextual ribbon tabs.

The slide-render corpus is independently complete: PowerPoint COM references
cover 53 slides in 27 decks, and the current-source recalibration includes
both a WPF and an Avalonia result for every reference slide.  That corpus
measures slide rendering rather than application chrome.

## Capture Contract

Run from the repository root:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Capture-FreePPowerPointChrome.ps1
```

The tool starts its own blank PowerPoint presentation, checks that the
PowerPoint process and exact window title own the foreground before every tab
selection and screen capture, and stops only the PowerPoint PID it started.
It retains either a complete `manifest.json` with 28 PNGs or a
`blocker-manifest.json`; it never retains partial evidence.

## Current Result

The active interactive Windows session completed the full matrix on
2026-08-16.  `manifest.json` records all 28 expected PowerPoint-owned ribbon
states (seven mapped tabs at four widths), including a SHA-256 digest and
physical dimensions for each PNG.  The capture was made from a blank
PowerPoint presentation and the process it created was closed after the
capture.

| Native PowerPoint ribbon reference | States | Result |
| --- | ---: | --- |
| Home, Insert, Design, Transitions, Animations, Slide Show, View at 1280, 1100, 900, and 750 logical widths | 28/28 | Complete foreground-guarded baseline |

The guard was exercised during setup, resize, tab selection, and every screen
copy.  The harness also attaches its transient input queue before requesting
Windows activation, then checks the exact PowerPoint PID and title again; it
does not treat a requested activation as proof of ownership.  Consequently,
another app reclaiming foreground still discards the entire incomplete run.

This is authoritative Office chrome evidence for semantic review, not a raw
pixel-equivalence pass for FreeP's WPF or Avalonia shell implementations.

The verifier accepts either honest outcome:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Test-FreePPowerPointChromeEvidence.ps1 -Check
```

Use the complete matrix for semantic chrome review alongside the paired FreeP
WPF/Avalonia whole-window report.  Do not use its pixels to declare a
pass/fail threshold until a named region mapping and acceptance criteria are
added.
