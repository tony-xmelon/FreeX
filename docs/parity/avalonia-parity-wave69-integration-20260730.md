# Avalonia parity Wave69 integration

Date: 2026-07-30

Wave69 integrated one bounded parity slice for each app. It does not claim
whole-application 100% parity.

## FreeX

- Production Name Box popup is attached to the Avalonia logical tree and uses
  the deterministic five-row WPF authority fixture.
- Native X11 capture passed 1/1 with one new `208x136` popup window and an
  unscaled, nonblank-interior root crop.
- WPF capture passed 1/1.
- Paired comparison passed with both surfaces present, zero hard regressions,
  and an informational `8.4793%` chrome difference.
- Focused managed verification passed: 8 zoom-planner tests, 4 WPF source
  guards, 25 Avalonia Name Box/capture tests, and 7 Linux runner guards.

## FreeW

- Ten Font and Paragraph dialog states were recaptured against WPF authority.
- Font changed pixels improved from `12.962%` to `11.490%`; mean delta improved
  from `11.55` to `10.31`.
- Paragraph changed pixels improved from `9.622%` to `8.594%`; mean delta
  improved from `10.95` to `10.03`.
- Focused Avalonia verification passed 21/21.
- All ten states remain genuine visual mismatches; thresholds and
  classifications were not weakened.

## FreeP

- Shared pointer planning and Avalonia capture/edge autoscroll behavior passed
  41 focused managed tests.
- The Linux pointer-selection lane passed 5/5, including release 64 pixels
  below the editor, forward/reverse selection readback, and unchanged fixture
  hash.
- Pixel comparison of native WPF versus Avalonia selection highlighting remains
  a later visual-fidelity slice.
