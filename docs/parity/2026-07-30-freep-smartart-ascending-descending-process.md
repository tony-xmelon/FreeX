# FreeP SmartArt Ascending and Descending Process

PowerPoint's common `ascendingProcess` and `descendingProcess` SmartArt layouts now
retain their native layout identities through FreeP's shared Change Layout route. The
existing renderer-neutral Process geometry remains the shared WPF/Avalonia consumer, while
undo, package refresh, and both host galleries expose the layouts as editable choices.
This is a functional/package reachability slice; it makes no new PowerPoint raster-fidelity
claim.
