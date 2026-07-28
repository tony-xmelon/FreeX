# FreeP Functional Wave 43

The Avalonia named custom-show launch path now assigns the visible editor window as the slideshow owner, matching the WPF `Owner = this` route. This keeps the slideshow attached to the authoring session for activation and lifetime behavior; headless source coverage guards both the owned and startup/unowned branches.

Residual: PowerPoint-authoritative custom-show visual baselines and richer drag-reorder polish remain deferred.
