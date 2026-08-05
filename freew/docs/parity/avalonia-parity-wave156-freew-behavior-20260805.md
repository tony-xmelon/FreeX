# Wave 156 FreeW behavior parity

## Scope

This slice closes two bounded FreeW behavior gaps where Avalonia depth was weaker than
the WPF authority surface:

- the Manage Sources master-list and current-document list now open the corresponding
  edit dialog on double-click, matching the existing WPF interaction;
- Avalonia now carries focused regression evidence for a refreshed Table of Authorities
  that uses `UsePassim`, preserves the marked citation formatting, and carries the WPF
  tab-leader geometry through the shared planner and Avalonia host.

## Evidence

- Avalonia source-management policy guard verifies both `DoubleTapped` edit routes.
- WPF source-management policy guard verifies both `MouseDoubleClick` edit routes.
- Avalonia References tab regression verifies `Roe v. Wade\tpassim`, preserved bold/
  underline/color formatting, `TabLeader.Dashes`, replacement of the stale region, and
  preservation of the following document paragraph.
- Shared planner authority remains in `SourceManagementDialogPlanner` and
  `TableOfAuthoritiesRegionPlanner`; no platform-specific policy was duplicated.

## Verification

All focused verification was then rerun serially with disabled build servers and
single-node compilation:

- `FreeW.App.Avalonia.Tests`: 67 passed, 0 failed. This covered References tab,
  numeric citation insertion/live renumbering, source-management policy, and the
  new TOA passim/formatting regression.
- `FreeW.App.Host.Tests`: 13 passed, 0 failed. This covered the WPF source-manager
  interaction guard and Mark Citation/TOA editor behavior.
- `FreeW.App.Presentation.Tests`: 64 passed, 0 failed. This covered shared source
  management and TOA region planning.

The first baseline attempt was invalid because two test commands were launched
concurrently and contended on a shared localization resource (`CS2012`); it was not
treated as a product failure and was followed by the serial green runs above.

## Residuals

This does not claim Word COM or native WPF/Avalonia pixel identity. A Wave 157 authority
audit confirmed that WPF Manage Sources does not expose clipboard or file interchange,
so those are not Avalonia parity residuals. The remaining document-editing breadth and
dialog visual fidelity remain separate work.
