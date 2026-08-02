# FreeP Summary Zoom Preview Parity

Authored Summary Zooms now render the first slide in each selected section through the active host
renderer. The shared `SummaryZoomPreviewPlanner` stores each PNG as a preserved media part, adds a
standard image relationship, and patches the matching native `summaryZmObj` preview payload. WPF and
Avalonia use the same attachment logic with their existing slide PNG renderers.

The preview path is intentionally best-effort: a renderer failure leaves the target metadata and the
legacy AlternateContent fallback intact. Package round-trip tests verify all preview parts and
relationships survive save/reopen. PowerPoint-exact cover styling and per-tile formatting remain open.
