# FreeW Reviewing Pane shared row plan (2026-08-13)

## Gap

Reviewing Pane rows still derived user-visible semantics inside each renderer. WPF used `Unknown`,
verb titles, and normalized wrapped text; Avalonia used `(unknown)`, noun badges, quoted/truncated
raw text, plus locally formatted dates and action tooltips. The two surfaces therefore described
the same revision differently and could continue drifting.

## Change

`ReviewingPaneRowPlanner` now produces one renderer-neutral plan containing author fallback, kind
label, WPF-compatible title, normalized preview text, compact date text, and Accept/Reject tooltips.
Both hosts consume that plan.

Avalonia retains its richer native badge, date, and per-row action controls, but now matches WPF's
author and preview semantics: `Unknown`, unquoted line-normalized text, wrapping instead of a
renderer-local 60-character cutoff, and no empty preview/date rows. WPF remains visually unchanged;
its native controls now render shared text rather than deriving it.

## Verification

- `dotnet test freew/FreeW.App.Presentation.Tests/FreeW.App.Presentation.Tests.csproj --configuration Release --no-build` — 1474 passed.
- `dotnet build freew/FreeW.App.Host/FreeW.App.Host.csproj --configuration Release` — passed, 0 warnings.
- `dotnet build freew/FreeW.App.Avalonia/FreeW.App.Avalonia.csproj --configuration Release` — passed, 0 warnings.

No UI, app-startup, screenshot, capture, or headless-Avalonia tests were run on this machine.
