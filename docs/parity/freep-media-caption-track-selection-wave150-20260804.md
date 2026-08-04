# FreeP Wave 150 Media Caption Track Selection

Date: 2026-08-04

## Gap

PowerPoint media can carry multiple playable caption tracks, but FreeP's WPF
and Avalonia slideshow controllers always displayed the first playable track.
The existing media-caption pane already tracked the selected caption row, so a
user could edit or inspect a Spanish track while slideshow playback silently
used English.

## Behavior

The selected caption row now follows the normal slideshow launch from either
host when the selected media shape is on the editor's current slide. The
preference carries the source presentation slide index through the route, so a
same-ID shape on another slide cannot consume it. The shared selector chooses
the requested track only for that source slide and falls back to the first
playable track when the selection is absent, invalid, or not playable. Hidden
slide reveals and custom-show routes use their resolved source index. Caption
package data is not mutated by this preference.

## Reachability

- WPF `MainWindow` passes the selected media-caption row to `SlideShowWindow`.
- Avalonia `MainWindow` passes the same selection to its `SlideShowWindow`.
- Both slideshow media controllers use the shared transcript selector.

## Verification

- Shared selector regression: 1/1 passed.
- WPF preferred-track overlay regression: 1/1 passed.
- Avalonia preferred-track overlay regression: 1/1 passed.
- Existing media package multi-track read/write/reopen coverage remains part of
  the focused host media lane; no package mutation is introduced here.

## Residual boundary

This is a slideshow playback preference, not a persisted presentation setting:
FreeP does not claim a PowerPoint-compatible global caption-language preference,
external caption fetching, or native COM playback parity. The preference is
limited to the selected editor media shape for a normal launch.
