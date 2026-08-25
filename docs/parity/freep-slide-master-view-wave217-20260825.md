# FreeP Slide Master View — Wave 217 (2026-08-25)

FreeP now exposes **View > Slide Master** in both WPF and Avalonia ribbons.

The view binds the native canvas to a real `MasterEditingSession`, not a cloned slide:

- master and layout placeholder roots compose in the owning master/theme context;
- selection, marquee, keyboard nudge, move, resize, rotate, multi-select transforms, and delete use undoable master/layout commands;
- the current target saves and reopens through the normal PPTX master/layout writer;
- returning to Normal restores the normal slide editing canvas and its rich-text/table overlay path.

The master-navigation pane exposes each master root and its layouts, so either surface can be selected and edited in both native hosts. Master-specific rich-text/format-painter editing and crop/custom-geometry point editing remain follow-up depth work; they are not represented as completed PowerPoint parity. Ink/Draw behavior and map-chart fidelity remain outside the active parity scope.

Focused evidence:

- `MasterEditingSessionTests`: 9/9, including save/reopen and shared canvas-router gestures.
- `FreePRibbonCommandWorkflowTests` plus master-session tests: 56/56.
- WPF `SlideMasterView` host tests: 2/2, including layout selection.
- Avalonia `Slide_master_view` host tests: 2/2, including layout selection.
- WPF and Avalonia host Release builds: passed with 0 warnings/errors.
- regenerated FreeP command inventory: 719 shared-profile commands, no actionable WPF/Avalonia command gaps.
