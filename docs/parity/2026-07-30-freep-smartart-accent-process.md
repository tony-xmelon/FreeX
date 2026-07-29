# FreeP SmartArt Accent Process

PowerPoint's common `accentProcess` SmartArt layout was already compatible with FreeP's
renderer-neutral Process geometry, but its native layout identity was absent from the live
allow-list and Change Layout gallery. FreeP now preserves and authors the native
`urn:microsoft.com/office/officeart/2005/8/layout/accentProcess` identity, keeps the diagram
live through the existing undo/package/cache route, and exposes matching WPF and Avalonia
commands. This is functional/package parity; no new PowerPoint raster-fidelity claim is made.
