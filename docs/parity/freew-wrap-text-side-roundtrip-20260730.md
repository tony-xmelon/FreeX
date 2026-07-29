# Floating Wrap Side Round Trip

## Scope

Word stores the side policy for square and tight floating objects separately from
the broad wrap mode. FreeW now preserves the `wp:wrapSquare/@wrapText` and
`wp:wrapTight/@wrapText` values in `FloatingWrapTextSide` for both floating
drawing placements and images.

Supported values are `bothSides`, `left`, `right`, and `largest`. The default is
`bothSides`, retaining existing writer behavior for new objects and documents
without an explicit token.

## Why It Matters

The matched `wordart-watermark-stress.docx` source uses
`wrapSquare wrapText="bothSides"` for its green floating text box. The previous
model retained only `Square`, which made side-aware Word layout impossible to
implement without fixture-specific inference.

## Verification

`FloatingObjectRoundTripTests` and `ImageWrappingRoundTripTests` passed 19/19
after validating non-default writer XML and reopened-model values.
