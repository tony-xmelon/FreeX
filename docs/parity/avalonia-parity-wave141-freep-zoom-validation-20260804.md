# Avalonia Parity Wave 141: FreeP Zoom Validation

## Audit

The existing Zoom Format workflow already shared target selection, transition,
frame-border color, crop, Summary tile layout, persistence, and undo. A host
audit found one remaining behavioral mismatch in the dialog boundary: WPF
reported invalid duration, border color, crop, or Summary tile layout through a
modal warning and kept the format dialog open, while Avalonia rendered a
host-only inline red status line.

## Implementation

- `ZoomObjectPropertiesPlanner` now owns the four validation messages used by
  both desktop hosts.
- WPF continues to use its warning `MessageBox` with those shared messages.
- Avalonia now uses the shared `AvaloniaUserMessageDialog.ShowWarningAsync`
  warning surface and keeps the Zoom Format dialog open until the input is
  corrected or canceled.
- Valid input still follows the existing shared model, native XML persistence,
  undo, and compositor paths. No command or workflow inventory row was added.

## Evidence

- Avalonia host Zoom evidence: **3/3**.
- WPF host Zoom evidence: **3/3**.
- Shared Zoom planner/navigation/authoring tests: **67/67**.
- The affected Avalonia, WPF, and shared presentation projects compiled as part
  of those Release test runs with no reported warnings or errors.

## Residuals

The remaining Zoom residuals are broader PowerPoint-native style semantics
(theme-derived, gradient, pattern, width, dash, and effects) and authoritative
COM-backed visual capture. Those states remain preserved rather than guessed.
