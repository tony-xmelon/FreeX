# FreeP Functional Parity Wave 38

Date: 2026-07-27

## Scope

This wave closes one FreeP WPF-vs-Avalonia workflow and records the two known
regressions from the Wave 37 audit.

## Findings and fixes

- The original Avalonia font-family failure combined adaptive test setup with a
  production lookup weakness. At the default headless width the Font group is
  collapsed, while a rendered ComboBox inside a realized tab template is not
  guaranteed to appear among logical descendants.
- The durable test now renders the ribbon at a width that keeps the group
  visible, drains pending layout jobs, and locates the rendered control through
  visual descendants. Production combo lookup now does the same and retains a
  logical-tree fallback, so key-tip execution targets the control that is
  actually rendered instead of depending on incidental logical-tree exposure.
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
