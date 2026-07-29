# Avalonia parity wave 49

Date: 2026-07-29

## Scope

Wave 49 closed three bounded Avalonia behavior gaps while retaining WPF as the
reference:

- FreeX: PivotTable field-list dragging now supports midpoint-based insertion,
  same-bucket reordering, positional cross-bucket insertion, and exact Values
  field moves without duplication.
- FreeW: the five inherited Avalonia guard failures from Wave 48 are closed,
  including ordinary proofing-run coalescing through undo-safe cloned runs.
- FreeP: nested key-tip routing now defers `Blink=B` while the longer
  `Blinds In=BI` dropdown sequence is reachable.

The wave also added physical Linux evidence for the FreeP nested key-tip route,
integrated concurrent FreeP animation-subtype and SmartArt work, and fixed the
missing Circle Accent Timeline label and key-tip resources found by final
generated-evidence validation.

This wave does not claim complete Avalonia/WPF parity.

## Verification

Focused and app-level tests:

- FreeX shared pivot drag validator: 15/15 passed.
- FreeX Avalonia pivot field-pane guards: 2/2 passed.
- FreeW focused residual lane: 11/11 passed.
- FreeW full Avalonia suite: 1,401/1,401 passed on the integrated FreeW slice.
- FreeP key-tip lane: 17/17 passed.
- FreeP key-tip inventory lane: 4/4 passed.
- FreeP final-sync animation round-trip lane: 28/28 passed.
- FreeP final-sync Avalonia key-tip and headless lane: 312/312 passed.
- FreeP final-sync WPF host ribbon lane: 192/192 passed.
- FreeP ribbon-definition suite after localization repair: 27/27 passed.
- FreeP localization suite: 21/21 passed.
- Linux family harness contract tests: 9/9 passed.

Repository validation:

- `FreeX.DefaultTests.slnx`, Release: 33,019 passed, 0 failed, 133 skipped.
- Final `FreeX.slnx`, Release: build succeeded with 0 warnings and 0 errors.
- Final repository preflight passed, including solution inventories,
  Linux/macOS packaging, generated parity documentation, 33/33 paired FreeP
  whole-window evidence metadata, and conflict-marker checks.

The 133 skipped tests remain an explicit coverage gap and are not parity
evidence. The default lane ran before the final concurrent FreeP-only sync; all
source scopes changed by that sync were then rebuilt and covered by the focused
FreeP lanes listed above.

## Linux evidence

FreeP physical X11 interaction passed 23/23 with the family contract passing:

- `artifacts/avalonia-parity-wave49/freep-linux-family-rerun/freep/sessions/20260728T231656319Z/family-validation/family-x11-results.json`

The new row physically inserts and selects a text box, enters `Alt,A,N,B`,
proves that the longer `BI` sequence remains live, opens the Blinds menu with
`I`, and dismisses both the menu and key-tip mode before the following
Backstage checks. The harness-owned container was stopped after capture.

## Generated status

- FreeP command inventory: 537/537 commands in both generated profiles, with
  zero actionable WPF-missing and zero actionable Avalonia-missing commands.
- FreeP dialog/pane evidence: 28/28 current.
- FreeP whole-window evidence metadata: 33/33 paired, with no explicit product
  mismatches or capture limitations in the generated manifest.
- The Circle Accent Timeline command now resolves `Circle Accent Timeline` and
  key tip `CT` in both WPF and Avalonia instead of a missing-resource token.

These inventory and manifest results prove coverage and evidence freshness, not
pixel-identical rendering.

## Known residuals

- FreeX pivot reordering has shared behavioral and Avalonia source guards, but
  the Linux physical fixture does not yet seed a PivotTable field pane. A real
  pointer-drag X11 row and matched WPF/Avalonia visual pair remain outstanding.
- FreeW has no remaining failure in the tested 1,401-test Avalonia scope, but
  Word-authoritative visual baselines and broader live document editing evidence
  remain incomplete.
- FreeP nested key-tip behavior now has physical Linux evidence, but
  PowerPoint-authoritative visual/playback baselines remain incomplete.
- The repository still has 133 intentionally skipped performance or
  environment-dependent tests.

## Next slices

- FreeX: add a seeded PivotTable Linux fixture and physically exercise
  same-bucket and cross-bucket field-list dragging, then capture a matched WPF
  and Avalonia field-pane pair.
- FreeW: continue real Word-backed drawing, chart, table, page, and editing
  comparisons.
- FreeP: continue PowerPoint-backed SmartArt, animation, media, OMML, and
  whole-window acceptance baselines.
- Cross-app: keep command inventories green while replacing source-only guards
  with physical interaction and authoritative visual evidence.
