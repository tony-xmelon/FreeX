# FreeW WordArt Two-Column Anchor Parity - 2026-07-16

## Scope

This slice fixes the WPF floating-object anchor estimate used by the WordArt +
picture-watermark fixture. The old estimate treated a narrow multi-column
paragraph as if it still had the single-column 92-character line capacity,
placing the floating WordArt about 64 DIP above the Word position. Avalonia's
shared planner already used the real column width.

## Change

`FreeW.App.Host.DocumentView.EstimateLeadingContentHeightDip` now derives the
line capacity for multi-column documents from the shared column plan while
preserving the existing single-column estimate. This keeps WPF's overlay canvas
anchored consistently with the shared placement planner.

## Verification

Focused WPF floating-object tests pass **13/13**, including a regression that
loads `BuildWordArtPictureWatermarkLayoutDocument` and verifies its two-column
WordArt overlay is placed below the old single-column estimate.

The focused visual run was generated under the temporary ignored path
`freew-fidelity-corpus/runs/wordart-column-anchor-20260716` and compared against
the cached real-Word PNGs; its generated artifacts were removed with that
temporary worktree after verification. WPF's picture-watermark page improved from mean
channel delta `25.2038` / changed pixels `20.326%` to `20.0013` / `18.615%`.
The single-column WPF stress page remained unchanged at `22.0118` / `17.282%`.

This is renderer evidence only: the cached Word PNGs are from the earlier
visible-publish baseline, and a fresh COM export was not issued against the
contended user Word session.
