# Avalonia/WPF parity wave 143 integration

Date: 2026-08-04

## Scope

Wave 143 closed four evidence-backed host divergences:

- FreeX: aligned the Avalonia Change Chart Type picker with the WPF two-row geometry, shared action-button sizing, compact chrome, keyboard lifecycle, and automation names.
- FreeW: introduced one shared About presentation contract for both hosts and aligned the Avalonia `about.initial` and `about.populated` content bounds with the retained WPF authority at `513x531`.
- FreeP: centralized slideshow media volume normalization so WPF and Avalonia both enforce the shared `0-100` boundary before adapting to their native media APIs.
- Shared shell: made Avalonia warning/error message-dialog severity, localized titles, compact chrome, default/cancel action behavior, access keys, and automation metadata explicit.

## Generated evidence

- The fresh Linux Change Chart Type capture is nonblank, exact `640x390`, and completed with `app_exit=0` and `capture_validated=true`.
- FreeX remains complete for declared dialog inputs at 57/57 routes and 94/94 paired screenshot surfaces, with zero nonblank, logical-size, or expected-size failures. Change Chart Type triage improved from `0.084227` to `0.077239`.
- Fresh FreeW Avalonia About captures matched the retained WPF content bounds at `16,16,513x531` for both states. Fresh WPF recaptures remained zero-pixel and were rejected rather than promoted.
- FreeP command evidence did not require regeneration because this slice changes an already modeled runtime boundary, not route coverage.

## Verification

- Shared Avalonia message-dialog parity: 1/1 passed.
- FreeP media parity: WPF 34/34 and Avalonia 10/10 passed.
- FreeX Change Chart Type: shared planner 179/179, WPF host 4/4, and Avalonia source 10/10 passed.
- FreeW About: Avalonia authority 1/1, WPF help 9/9, and shared presentation 3/3 passed.
- Dialog visual evidence summary check passed and all generated documentation remained current.
- Repository preflight passed.
- The full 101-project Release build passed with zero warnings and zero errors.
- The default lane retained the established 26 FreeX and four FreeP WPF raster failures. Representative failures remained all-zero when rerun in isolation, confirming the current WPF RenderTargetBitmap outage rather than a Wave 143 behavioral regression.
- The complete FreeX Avalonia suite passed 2,028/2,028 in the default lane.

## Evidence boundaries

The retained WPF Change Chart Type and FreeW About captures remain the valid authorities because current-source WPF recaptures still produce blank output on this host. Route, command, and focused semantic coverage are not treated as proof of complete visual parity. Native media devices/codecs, COM baselines, and remaining pixel-level dialog differences remain later parity work.
