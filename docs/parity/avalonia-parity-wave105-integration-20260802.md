# Avalonia parity Wave 105 integration

Date: 2026-08-02

## Delivered

- **FreeX:** Avalonia pointer-wheel input now preserves coalesced notch magnitude through
  the shared viewport planner for vertical, horizontal, Shift-wheel, and Ctrl-wheel zoom
  routes. The WPF 120-unit native wheel path remains unchanged.
- **FreeP:** portable Avalonia now has an application-owned printer/settings dialog backed
  by shared print-selection planning and real CUPS queue discovery/submission. The Windows
  `PrintDlgEx` route remains intact.
- **FreeW:** shared Backstage Account/action-pane metrics now drive both WPF and Avalonia.
  Fresh paired Account and Export captures were folded into the canonical visual report.

## Physical Linux evidence

`tools/Run-FreePPortablePrinterValidation.ps1` runs the real FreeP Avalonia UI in the
serialized Docker/X11 harness and drives File > Print with physical X11 pointer and keyboard
input. Its private fake CUPS boundary exposes two deterministic queues but does not bypass
the application UI or print workflow.

The accepted run passed **9/9** gates: owner visibility, File > Print routing, portable dialog
visibility and same-process ownership, control interaction, non-default queue selection,
settings submission, exact `lp` arguments, submitted PDF capture, and owner-focus restoration.
It submitted `FreeP-Secondary`, two copies, pages 2-3, landscape, and uncollated output; the
captured PDF was 6,984 bytes. The runner stopped its exact container on completion.

## Focused verification

- FreeX shared planner: 13 passed.
- FreeX WPF viewport facade: 14 passed.
- FreeX Avalonia coalesced-wheel route: 1 passed.
- FreeP print selection planner: 3 passed.
- FreeP CUPS and Windows printer contracts: 9 passed.
- FreeP broader Avalonia print lane: 27 passed.
- FreeP physical-lane source contract: 4 passed.
- FreeW presentation Backstage planner: 19 passed.
- FreeW WPF Backstage dedup/composer lane: 24 passed.
- FreeW Avalonia Backstage view lane: 39 passed.

## Visual position

The refreshed FreeW Account pair passes at 2.5366% changed pixels with no semantic
difference. Export remains a genuine visual mismatch at 13.5435% changed pixels, also with
no semantic difference. The canonical aggregate now records 17 passes and 166 genuine
visual mismatches for the current FreeW comparison corpus.

## Repository gates

- Repository preflight passed, including generated-document freshness and Linux packaging.
- `dotnet build FreeX.slnx --configuration Release` passed with zero warnings and errors.
- The parallel default solution produced 35,431 passes, 133 skips, and three failures.
  All three were isolated as concurrency effects: the complete WPF host-logic project passed
  1,493 with four skips when run alone, the text-to-columns performance case passed 1/1,
  and all 11 aggregate performance cases passed alone. The FreeP source-policy failure from
  the first run was a stale exact-signature assertion after upstream added the optional Zoom
  transition parameter; the assertion now anchors on the method name and the full FreeP
  Avalonia project passes 556/556.

## Remaining boundaries

Wave 105 closes the selected functional residuals; it does not claim repository-wide 100%
visual parity. The largest quantified backlog remains the 166 FreeW genuine visual
mismatches, led in this wave by Export. Printer-driver-specific settings, OS-owned portable
print chrome, real printer hardware, COM/OLE availability, and Linux desktop wheel preference
discovery remain explicit platform or external-system boundaries.
