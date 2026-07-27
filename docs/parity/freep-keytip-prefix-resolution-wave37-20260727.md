# FreeP key-tip prefix resolution, Wave 37

The shared `RibbonKeyTipResolutionPlanner` now applies the WPF key-tip rule to
Avalonia group, direct-control, and nested-menu scopes:

- an exact enabled key tip executes immediately when no longer enabled key tip
  starts with it;
- an exact key tip is held as a prefix when a longer enabled candidate exists;
- disabled candidates do not block an enabled exact or longer prefix;
- no-match input keeps the outer Avalonia key-tip mode recoverable, while an
  unmatched nested-menu input closes the menu as before.

The FreeP ribbon definition allocation was intentionally left unchanged. For
WPF-compatible menu behavior, an exact menu leaf remains immediate when a
longer leaf shares its prefix; only a longer enabled submenu parent defers the
exact selection.

The confirmed `Blink=B` / `Blinds In=BI` case now waits for the second
character, allowing `BI` to enter the WPF-equivalent animation menu.
WPF continues to use native key-tip routing; its production ribbon definition
and nested-menu key-tip authority are covered by focused parity tests.
