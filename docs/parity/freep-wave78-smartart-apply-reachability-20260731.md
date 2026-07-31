# FreeP Wave 78 SmartArt Apply Reachability

## Function slice

The Avalonia SmartArt text pane already owned the same outline mutation path as
the WPF host: text replacement routes through `SmartArtEditingPlanner`, refreshes
the native data part and drawing cache, and remains undoable. The physical Linux
probe could not exercise that path because the fixed 320-DIP pane placed its five
command buttons in one horizontal stack. `Apply` and `Close` were therefore
outside the pane viewport.

The command strip now uses a width-aware wrapping panel. It stretches to the
available pane width, so the actions wrap into visible rows at the fixed physical
pane size while the outline remains independently scrollable. No SmartArt model,
package, or mutation semantics changed.

## Evidence boundary

The headless source contract proves the fixed-width command strip uses wrapping
and contains reachable Apply/Close controls. The existing physical runner still
proves Add sibling, save, and reopen. A fresh X11 run is required before claiming
physical Apply/text replacement evidence; this slice does not claim that run.
