# FreeP chart series order parity

FreeP's chart reader previously used the physical order of `c:ser` elements as
the series order and discarded the authored `c:order` values. PowerPoint can
retain a different XML element order after a series edit, so reopening such a
deck could change plot and legend ordering.

The reader now honors `c:order` when every series in a plot group provides the
token, while preserving source order for incomplete producer payloads. The
regression test rewrites a valid chart package with reversed XML series order
and verifies that the reopened model follows the authored order.

This is a functional/package-parity fix; it does not claim a visual raster
improvement.
