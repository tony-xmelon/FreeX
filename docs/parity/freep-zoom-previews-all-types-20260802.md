# FreeP Zoom previews: all native target types

## Scope

Slide Zoom and Section Zoom insertion now attach a rendered PNG preview immediately after the native target
graphic frame is created. Summary Zoom already used the same relationship-backed package path; the planner now
shares the single-target attachment logic across all three Zoom types.

The active WPF and Avalonia slide renderers remain the source of preview pixels. The shared planner owns only
target validation, `zmPr`/`blipFill` XML updates, image relationships, content types, and preserved media parts.
PowerPoint remains authoritative for the optional preview styling and cover-image authoring model.

## Evidence

- `ModernObjectsRoundTripTests`: 22/22, including Slide and Section Zoom preview parts through write/reopen.
- Zoom insertion planner tests: 11/11.
- Avalonia Zoom/source checks: 1/1.
- WPF and Avalonia Release test-project builds: 0 warnings, 0 errors.
- Preview media is asserted by relationship-backed `image/png` parts and native `blipFill` payloads; generated
  graphic-frame IDs are intentionally not treated as stable package identifiers.

## Remaining

PowerPoint-exact cover-image authoring, preview crop/cover styling, and broader native Zoom transition semantics
remain separate functional slices. This change establishes the common preview payload and host insertion path.
