# FreeP hidden-slide reveal

## Scope

PowerPoint does not show hidden slides during ordinary slideshow playback, but a presenter can press `H` to reveal the next hidden slide. FreeP already skipped hidden slides and mapped numeric deck jumps correctly; it did not provide the on-demand reveal behavior.

## Behavior

- Full-presentation playback searches the source deck for the next hidden slide after the current source slide.
- A named custom show can reveal only hidden slides explicitly included in that show.
- The reveal is transient: the playback controller remains on the visible route, and the next navigation command clears the revealed slide before applying normal playback.
- WPF and Avalonia use the same planner policy and rendering behavior.

## Verification

- Shared planner: 23/23 focused tests.
- WPF slideshow host: 4/4 focused tests.
- Avalonia slideshow host: 4/4 focused tests.
