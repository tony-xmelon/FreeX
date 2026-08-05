# FreeP Zoom Return Transition Parity

## Scope

PowerPoint Zoom navigation now carries the authored transition duration and `showBg` behavior through the
Return to Parent stack. Leaving a Slide, Section, or Summary Zoom target through either Advance or Back uses the
same Zoom transition contract as entering the target. Ordinary slide navigation and Zoom objects without Return
to Parent remain unchanged.

## Evidence

- Shared `SlideShowHostPlannerTests`: 112/112, including Advance and Back return paths with duration/background.
- WPF `FreeP.App.Host` Release build: 0 warnings, 0 errors.
- Avalonia `FreeP.App.Avalonia` Release build: 0 warnings, 0 errors.

## Remaining

PowerPoint-exact Zoom cover crop/position authoring and broader native Zoom transition rendering remain separate
parity work. This slice closes the authored Return to Parent transition state loss only.
