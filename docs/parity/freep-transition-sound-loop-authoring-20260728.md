# FreeP transition sound loop authoring

PowerPoint's transition sound payload supports looping until another transition sound replaces it. FreeP already preserved the `p:stSnd/@loop` token through the model, PPTX reader/writer, slide cloning, and slideshow playback, but the authoring surface had no way to change it.

This slice adds a shared `freep.transition.sound-loop` toggle to the WPF and Avalonia transition ribbons. It flips only `TransitionSound.Loop` through the existing undoable transition command, preserving audio bytes, relationship identity, content type, and all other transition timing/effect settings. Tests cover planner dispatch, undo, and both host ribbon registration. This is functional/package parity evidence, not a raster-fidelity claim.
