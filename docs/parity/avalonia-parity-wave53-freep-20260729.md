# Avalonia parity Wave 53 - FreeP media seek validation

Date: 2026-07-29

## Closed slice

FreeP's WPF slideshow media controller rejects negative seek positions before
calling the native media element. Its existing regression coverage exercises a
valid seek followed by a negative seek and expects the latter to return false.
The Avalonia controller previously forwarded every position to the LibVLC
session, so an invalid negative request could be accepted by a fake or native
backend and diverge from WPF behavior.

Avalonia now applies the same non-negative seek contract at the controller
boundary. Valid seeks still reach the active media session; negative seeks
return false without touching the backend.

## Validation

- Avalonia media adapter focused tests cover valid seek, negative seek rejection,
  volume, click playback, transition sound lifecycle, and teardown.
- The WPF authority is `FreeP.App.Host.Tests/SlideShowTests.cs`, where the same
  controller contract asserts `TrySeek(shapeId, TimeSpan.FromSeconds(-1))` is
  false.
- Linux FreeP family physical validation passed 24/24 rows, including launch and
  slideshow workflows. Evidence:
  `artifacts/linux-family-interactive-wave53-freep-20260729/freep/sessions/20260729T111905743Z/family-validation/family-x11-results.json`.
- This is a functional host-contract fix, not a claim of exact PowerPoint media
  codec or timing parity.

## Remaining

- Real Linux media seek validation still depends on a playable media fixture and
  an interactive LibVLC route; the existing Linux FreeP family evidence does not
  exercise a seek control.
- PowerPoint-authoritative media timing, codec coverage, and native playback
  visuals remain outside this no-COM slice.
