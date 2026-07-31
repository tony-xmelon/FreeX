# Avalonia Parity Wave 74 Integration

Date: 2026-07-31

## Integrated Slices

- FreeX Scenario Manager now saves and edits typed or picked changing-cell
  ranges, parses optional result ranges for summaries, carries hidden and
  locked flags, and focuses the field that fails shared validation.
- FreeX interaction validation now disposes replaced workbook sessions while
  preserving live sibling views. This removes the accumulated session/resource
  retention behind the previously hanging exhaustive shortcut test.
- FreeW Tabs now follows the WPF layout, action order, focus, and modal
  validation contract. Fresh paired evidence reduced the average changed-pixel
  ratio from 14.0477% to 11.4102% and removed all semantic differences.
- FreeP clipboard evidence now records the already-shared XamlPackage import
  route and precedence contract. Production precedence remains custom-v2,
  XamlPackage, RTF, then plain text.

## Integrated Verification

- FreeX Scenario Manager: 5 Avalonia host tests, 15 shared planner tests, and
  75 shell/source tests passed.
- FreeX shortcut lifecycle: all 14 focused tests passed, including the full
  276-scenario production shortcut catalog.
- FreeW Tabs: 3 Avalonia parity tests, 2 WPF host tests, and 14 shared planner
  tests passed.
- FreeP clipboard: 22 shared parser tests, 8 WPF adapter tests, 26 Avalonia
  editor tests, and 31 Avalonia clipboard tests passed.
- The regenerated FreeP command parity inventory passes its authoritative
  generator check while retaining the newer inherited TTML/DFXP caption work.
- Repository preflight and the full 97-project Release build passed with zero
  warnings or errors. The 20-project default non-UI test solution passed after
  replacing a load-sensitive `Sleep(50)` assumption in the NOW idle-window
  regression with a measured-interval retry.

## Linux Production Evidence

The targeted FreeX production interaction route ran in the Ubuntu 24.04
interactive Docker desktop at 1280x820 and 96 DPI. All five results passed:
the Scenario Manager opener, modal ownership and keyboard focus cycle, changing
cells range pointing, and result cells range pointing.

The real FreeW application also ran in the Linux desktop at the same resolution
and DPI. X11 input opened the Tabs dialog through the Home ribbon Paragraph
overflow, added a 72 pt left tab stop through Set, and produced the expected
modal warning after entering a zero default tab interval.

## Remaining Boundaries

- FreeW Tabs retains an 11.36-11.49% native-template and text-rasterization
  pixel delta; its semantic contract is aligned.
- FreeP XamlPackage import remains intentionally bounded for unsupported
  resource dictionaries, arbitrary FlowDocument controls, inline object/image
  runs, broader IME/RTL behavior, and PowerPoint-authoritative visual baselines.
- This wave closes four bounded slices. It does not claim whole-suite or
  whole-product pixel parity.
