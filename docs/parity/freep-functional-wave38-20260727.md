# FreeP Functional Parity Wave 38

Date: 2026-07-27

## Scope

This wave closes one FreeP WPF-vs-Avalonia workflow and records the two known
regressions from the Wave 37 audit.

## Findings and fixes

- The Avalonia font-family key-tip failure was harness-only. At the default
  headless width, adaptive ribbon layout collapses the Font group, and the
  realized ComboBox is not exposed through the logical descendants used by the
  test. The production key-tip route was already correct. The durable test now
  renders the ribbon at a width that keeps the group visible, drains pending
  layout jobs, and locates the rendered control through visual descendants.
- Production combo lookup now prefers visual descendants and retains a logical
  tree fallback. This keeps key-tip execution aligned with the control that is
  actually rendered while preserving the existing route for non-templated
  controls.
- The unfiltered Avalonia Transitions expectation was stale. WPF/shared ribbon
  authority includes Rehearse Timings and Record Timings between the two slide
  playback commands and Custom Shows; the Avalonia definition test now asserts
  that same five-command order. No production change was needed.
- Avalonia now has a focused workflow test that executes the real MainWindow
  ribbon commands for Rehearse Timings and Record Timings, opens a
  SlideShowWindow for each, and verifies the shared timing intent. The existing
  WPF command and slide-show tests remain the authority for the matching route.

## Verification

Focused Avalonia run: 19/19 passed, including all KeyboardContextParityTests,
the Transitions definition test, and the new ribbon timing workflow.

Existing WPF/shared authority runs from the investigation: 115/115
RibbonTransitionsAnimationsTests and 19/19 FreePRibbonDefinitionProfileTests.

## Residuals

This is a focused functional slice, not a claim of whole-product parity.
Broader FreeP visual parity, full dialog coverage, and real desktop/hardware
validation remain in the aggregate parity backlog.
