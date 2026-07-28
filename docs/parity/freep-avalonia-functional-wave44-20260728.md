# FreeP Avalonia Functional Wave 44 - 2026-07-28

## Mismatch fixed

Avalonia's `MainWindow` previously reselected the editor slide when slideshow playback closed. The WPF launch path keeps editor selection unchanged while the separate slideshow window plays, so Avalonia now follows the same authority for normal and named custom-show routes.

The normal slideshow route still restores owner focus, which is a window-lifecycle concern and does not change document state. Playback continues to track its own current slide independently.

## Validation

- Avalonia source coverage asserts both hosts leave editor selection outside playback close.
- Headless slideshow coverage advances playback while the editor remains on its original slide.

This slice does not claim full PowerPoint-authoritative slideshow visual fidelity or hardware-backed recording parity.
