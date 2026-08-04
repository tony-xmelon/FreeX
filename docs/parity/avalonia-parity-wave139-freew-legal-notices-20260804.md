# Avalonia Parity Wave 139: FreeW Legal Notices

Date: 2026-08-04
Scope: FreeW Avalonia Legal Notices, four long-document tab states
Decision: retain a host-local one-pixel content registration correction.

## Audit and change

The WPF and Avalonia dialogs already share the notice ordering, packaged text,
dialog dimensions, tab behavior, read-only document host, scrollbar policy,
automation IDs, and keyboard lifecycle. The remaining measurable structural
delta in the last valid paired authority was the Avalonia document root starting
one pixel too low and ending one pixel too early.

`AvaloniaLegalNoticesDialog` now uses a top content margin of `15` while keeping
the shared `16` left/right/bottom margins and all neutral `LegalNoticesDialogMetrics`
unchanged. This is intentionally local to the Avalonia host; the WPF dialog and
other shared read-only document consumers are unaffected.

## Before and after evidence

The canonical comparison rows before this slice were retained as the paired
authority because they were generated from valid WPF pixels:

| State | Canonical changed ratio | Canonical mean channel delta |
| --- | ---: | ---: |
| `tab-legal-notices` | 18.0067% | 18.741 |
| `tab-privacy-notice` | 16.6809% | 18.685 |
| `tab-third-party-notices` | 17.6247% | 19.156 |
| `tab-third-party-license-texts` | 17.9720% | 20.004 |

Fresh Avalonia captures for all four requested states passed the full pixel
content gate (`4/4`). Their content bounds changed from the prior Avalonia
authority `x=16,y=20,width=574,height=527` to
`x=16,y=19,width=574,height=528`, matching the WPF authority's vertical
registration (`x=16,y=19,height=528`) with the known one-pixel Avalonia width
difference. The fresh captures also covered all six Legal Notices route states
(`288/288` Avalonia scenarios captured and gated).

The canonical changed-pixel ratios are deliberately not replaced: the fresh
WPF run produced `0/190` valid frames. Every WPF frame failed the content gate
as zero-pixel/near-transparent output, including the four target states. It is
not valid visual evidence and was not promoted over the prior WPF authority.

## Functional verification

- Avalonia Legal Notices visual/keyboard/automation tests: `13/13` passed.
- WPF Help/Legal Notices provider and dialog tests: `9/9` passed.
- Avalonia dialog harness Release build: `0` warnings, `0` errors.
- WPF dialog harness Release build: `0` warnings, `0` errors.
- Fresh Avalonia harness: `288/288` captured, all content-gated.
- Fresh WPF harness: `0/190` valid because of the zero-pixel host outage.

The bounded `FreeW.slnx` Release build compiled all impacted app, shared-shell,
and harness projects, but could not complete because 20 unrelated test/tool
projects had no restored `obj/project.assets.json`. No broad restore was used
for this slice.

Residual visual differences remain platform text rasterization (WPF ClearType
versus Avalonia/Skia) and the one-pixel horizontal registration. No semantic,
tab, scrolling, focus, automation, or content difference was introduced.
