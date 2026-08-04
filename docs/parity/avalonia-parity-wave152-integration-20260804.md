# Avalonia parity Wave 152 integration

Date: 2026-08-04

Upstream base at integration start: `b4ef51bc42`.

## Accepted slice

- FreeW Side-to-Side view now has regression evidence that its live Avalonia
  editor preserves cross-page selection and document-wide undo while page-pair
  navigation changes the visible range. The stale clipboard/undo deferral was
  removed from the planner and parity note.

This slice verifies existing behavior; it does not claim that the remaining
horizontal page-grid layout is complete. Avalonia still needs native horizontal
page composition, page-aware hit testing, and pair scrolling equivalent to WPF.

## Clean audits

- FreeX's strongest candidate, Move Chart, is already implemented and wired in
  both hosts. Lock Cell, chart-series formatting, diagnostics copy, legal
  notices, and Convert to Comments were also confirmed paired.
- FreeP's command inventory remains complete. Transition-sound playback and
  cleanup, Zoom gradient/pattern/dash rendering, and slideshow repeat and
  auto-reverse behavior are implemented in both hosts. Remaining FreeP work is
  native, external, or evidence-bound.

## Rejected slice

An experimental Avalonia `IRibbonStateStore` binding was reviewed but not
integrated. No production Avalonia host owns or passes a `RibbonStateStore` to
the renderer, so the change only added test-covered optional API capability and
fixed no production behavior. Future state-store work must include actual host
wiring and a production behavior regression before it can count toward parity.

## Verification

- FreeW worker lane: `28/28` Release tests passed.
- Integration FreeW lane: `28/28` Release tests passed on the current upstream
  base with isolated single-node build settings.
- Repository preflight passed across `220` JSON files, `261` XML-backed files,
  `125` .NET projects, `92` solution entries, and `11,101` text files. Generated
  command, dialog, and visual-evidence documents are current.
