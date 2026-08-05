# FreeP media bookmark playback

Media bookmarks were already read from and written to PresentationML and could be
edited through both desktop media panes, but slideshow playback did not consume them.
The shared media interaction planner now resolves a named bookmark by trimmed,
case-insensitive name and clamps the result to the active trim window. WPF and
Avalonia expose the same `TrySeekToBookmark` playback-control operation, and both
reapply the authored fade/volume envelope after the seek.

This is a functional playback-control slice. It does not claim a new visual baseline
or a separate media-control UI; it extends the existing shape-id seek/volume adapter
surface and keeps the package model unchanged.

Focused proof:

- shared media planner contracts: 10/10;
- Avalonia media adapter tests: 14/14;
- WPF media-controller tests: 37/37;
- full Presentation test project: 3,735/3,735;
- affected Release consumers built with 0 warnings/errors.
