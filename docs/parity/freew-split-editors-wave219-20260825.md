# Wave 219 — FreeW synchronized Split editors

## Scope

FreeW's View > Window > Split no longer advertises a read-only paginated
projection. Both WPF and Avalonia now display a focusable, editable lower
document surface while retaining one canonical document for persistence,
autosave, and the surrounding document panes.

Ink/Draw interaction fidelity and map-chart fidelity remain explicitly outside
the current UX parity scope; this change introduces neither a drawing runtime
nor a geographic-data dependency.

## Interaction contract

- Entering Split commits the primary surface and opens a cloned lower editor.
- An edit from either pane is committed from that source and copied to its peer
  under a synchronization guard, avoiding recursion and stale preview content.
- Exiting Split restores the original workspace with its current canonical
  document.
- Keyboard/QAT Undo and Redo, status selection data, and the common
  cut/copy/paste/select-all routes resolve the active editor where their host
  command plumbing permits it.

The portable view-depth plan now identifies this as `SplitEditors`, has no
read-only snapshot limitation, and does not request print-preview rendering.

## Verification

- `FreeW.App.Presentation.Tests` filtered to `FreeWViewDepthPlannerTests`: 16 passed.
- `FreeW.App.Host.Tests` filtered to `PageViewModesTests`: 25 passed, including
  a lower-pane edit persisted to the canonical saved document.
- `FreeW.App.Avalonia.Tests` filtered to `ViewTabDepthTests`: 33 passed,
  including a lower-pane edit synchronized to the primary document.
- Release builds of `FreeW.App.Host` and `FreeW.App.Avalonia`: passed.
