# Avalonia parity Wave 106 integration

Date: 2026-08-02

## Delivered

- **FreeX:** the Avalonia Page Layout `Scale Width`, `Scale Height`, and
  `Scale Percent` ribbon controls now accept arbitrary typed values. Enter and
  focus loss commit through the existing shared parser and policy planner,
  selection plus focus loss remains single-shot, invalid text restores the
  current valid value, and live command state resynchronizes the controls.
- **FreeW:** Side to Side is no longer a read-only snapshot. WPF now hosts the
  existing editable paginated editor in horizontal flow, while Avalonia keeps
  its live editor attached and editable behind the shared view-depth and page-pair
  navigation contract.
- **FreeP:** a left press on a slide thumbnail explicitly selects that slide
  before beginning the shared drag session, matching the WPF interaction order
  instead of depending on `ListBox` default selection timing.

Wave 106 also merged the concurrent `main` work for FreeW page-boundary settings.
The primary dirty checkout and its Claude-owned build/review processes were not
modified or stopped.

## Focused verification

- FreeX Avalonia editable combo/callback lane: **137 passed**.
- FreeX WPF scale-combo source contract: **1 passed**.
- Shared Avalonia combo lane: **6 passed**.
- FreeW shared view-depth planner: **15 passed**.
- FreeW WPF page-view modes: **22 passed**.
- FreeW Avalonia view-depth surface: **27 passed**.
- FreeP Avalonia slide pane: **16 passed**.
- FreeP WPF slide pane: **25 passed**.
- FreeP shared slide-pane planning: **53 passed**.

## Physical Linux evidence

`tools/Run-FamilyLinuxInteractionValidation.ps1 -App FreeP` published the merged
FreeP Avalonia app for `linux-x64`, launched it in the serialized Docker/X11
harness at 1280x820 and 96 DPI, and passed **24/24** physical rows. The lane
includes real pointer selection of the second slide thumbnail, keyboard and
pointer context menus, create/undo/redo/delete workflows, nested keytips, and
the animation-pane workflow. The exact harness container was stopped on
completion.

## Generated evidence

- Generated-document checks pass.
- FreeP dialog/pane visual evidence remains **28/28** pass across 123 PNGs.
- FreeP whole-window evidence remains **33/33** paired with no explicit product
  mismatch or capture limitation; its source fingerprint was refreshed for the
  FreeP and shared Avalonia ribbon changes.
- FreeW and FreeP command inventories and the cross-app dashboard remain current.

## Repository gates

- Repository preflight passed, including generated-document freshness, Linux
  packaging, project references, JSON/XML validation, and conflict-marker checks.
- `dotnet build FreeX.slnx --configuration Release` passed with **0 warnings**
  and **0 errors**.
- The serialized default solution produced **35,439 passes**, **133 skips**, and
  one failure in the global WPF bitmap-clipboard flavor test. That exact test
  passed **1/1** immediately when isolated; no Wave106 source participates in
  its clipboard ownership path.

## Remaining boundaries

Wave 106 closes three bounded functional residuals; it does not claim repository-
wide visual parity. FreeW Avalonia still needs a native horizontal page-grid
layout with page-aware hit testing and pair scrolling. Cross-page clipboard/undo
depth remains incomplete, and Multiple Pages and Split retain read-only preview
components. FreeP still has richer WPF thumbnail rendering and external
PowerPoint-baseline work. The quantified FreeW visual mismatch backlog and the
broader matched-size human review corpus remain active.
