# FreeP Avalonia Home ribbon priority alignment — Wave 230 (2026-08-25)

## Scope

This slice aligns the FreeP Avalonia Home ribbon's responsive group priority with the WPF host.
The Avalonia profile ranked Arrange above Paragraph, so its 1280-DIP Home ribbon collapsed Paragraph
despite unused space while WPF retained Bullets and Numbering. The Avalonia priority order now matches
the WPF order: Slides, Clipboard, Font, Paragraph, then the lower-priority Arrange, Edit, and Editing
groups.

At desktop width, paragraph list commands remain immediately discoverable. At constrained widths, the
existing whole-group collapse behavior remains in place, including the 900-DIP Insert tile layout
accepted in Wave 229. This changes no command registration, command routing, document behavior, or
runtime dependency.

An initial renderer-wide WPF-style adaptive-policy probe did not improve the 1280-DIP result and was
discarded before this change. The accepted correction is limited to the host profile priority that
caused the visible ordering mismatch.

## Visual evidence

The canonical responsive FreeP matrix was recaptured at 1280, 1100, 900, and 750 DIPs for all eight
primary tabs in client and full-window forms. At 1280 DIPs, Avalonia Home now shows Bullets and
Numbering in Paragraph, matching the WPF interaction priority. At 900 DIPs, Avalonia Insert remains
whole-group collapsed rather than returning to the thin intermediate icon strip.

`Test-FreePResponsiveChromeEvidence.ps1` reports 64 paired WPF/Avalonia captures, and the capture
generator's `-Check` mode confirms all 64 are current.

## Verification

- Focused Home-priority and narrow-Insert-collapse tests — 2 passed.
- `dotnet test freep/FreeP.App.Avalonia.Tests/FreeP.App.Avalonia.Tests.csproj --configuration Release --no-build` — 730 passed.
- `Capture-FreePResponsiveChrome.ps1`, `Test-FreePResponsiveChromeEvidence.ps1`, and `Capture-FreePResponsiveChrome.ps1 -Check` — passed (64/64 captures).

Ink/Draw behavior and map-chart fidelity remain deferred by the [UX visual-parity scope](ux-visual-parity-scope-2026-08-25.md).
