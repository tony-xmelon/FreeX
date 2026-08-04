# Avalonia Parity Wave 139: FreeP Zoom Transition Authoring

## Scope

The function-first audit found that FreeP already had shared Zoom insertion,
target retargeting, Summary Zoom target-list editing, preview and cover-image
replacement, crop, and tile-layout persistence. The bounded missing authoring
operation was the Zoom Transition toggle: both desktop dialogs exposed only a
free-form duration field. An invalid or zero value could be persisted even
though slideshow navigation ignores it, and there was no explicit way to turn
the transition off while retaining a single shared authoring experience.

## Implementation

- `ZoomObjectPropertiesPlanner` now owns transition enablement and invariant
  millisecond normalization, with a 1000 ms default when enabled with an empty
  field.
- WPF and Avalonia `ZoomObjectPropertiesDialog` expose the same checkbox,
  enable/disable the duration editor together, and reject invalid enabled values.
- The existing shared `SetZoomObjectPropertiesCommand` remains the single
  persistence and undo boundary; disabling removes native `transitionDur`.
- No command inventory row was added: this is depth for the existing
  `freep.zoom.format` route, and the inventory remains unchanged at 648/648.

## Evidence

- Shared planner: `PresentationViewZoomPlannerTests`, 17/17 passed.
- WPF host route: `ZoomAuthoringParityTests`, 2/2 passed.
- Avalonia host route: `ZoomAuthoringParityTests`, 2/2 passed.
- WPF-hosted native XML persistence/undo: `ZoomTransition_ToggleIsUndoableAndRoundTripsNativeDuration`, passed.

## Residuals

Broader PowerPoint-native Zoom style/effect semantics and COM-backed visual
validation remain outside this bounded slice. The existing summary also retains
the platform boundaries documented in the function-first status report.
