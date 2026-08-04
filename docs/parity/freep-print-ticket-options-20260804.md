# FreeP native print-ticket option propagation

Date: 2026-08-04

## Scope

The shared `PresentationPrintRequest` already owns PowerPoint-style copy count,
collation, and color intent. The WPF native print path now seeds those values in
the `PrintDialog.PrintTicket` before the dialog opens. Users can still override
the defaults in the native Windows dialog; the application no longer silently
falls back to one collated color copy.

`Color` maps to `OutputColor.Color`, `Grayscale` maps to
`OutputColor.Grayscale`, and `PureBlackAndWhite` maps to
`OutputColor.Monochrome`. Copy count is clamped to the same 1-999 range used by
the shared planner.

## Boundary

This slice covers native WPF printer-ticket handoff. It does not claim that
portable CUPS submission or the raster/PDF package itself reproduces every
printer-driver color transform; those remain owned by their respective hosts.

## Verification

- `WpfPresentationPrintServiceTests.ApplyPrintTicketOptions_PropagatesSharedCopiesCollationAndColor`: passed.
- Existing WPF print-page-source and paginator tests remain covered.
