# FreeW theme-linked run-color retention

Date: 2026-08-04

## Gap

Word stores theme-linked text color in `w:color` using a cached `w:val` plus `w:themeColor` and
optional `w:themeTint` / `w:themeShade`. FreeW kept only the cached RGB value, so save converted the
text to a fixed color and broke its relationship to the document theme.

## Slice

- `RunFormatting` now retains an immutable Word theme-color source beside its renderer-ready RGB.
- The same reader path covers body runs, styles, fields, notes, headers/footers, and document defaults.
- Run and document-default writers emit the original theme token, tint, shade, and cached value.
- Theme metadata is emitted only while the cached RGB still matches its authored `w:val`. A later
  fixed-color edit therefore writes only the new RGB and cannot be overridden by a stale theme link.
- Style inheritance carries the theme source only when the inherited color remains authoritative.

## Package Evidence

An authored `accent4` run with both tint and shade reopens with cached `#7F6000`, saves with all four
source attributes, and becomes a plain `FF0000` color after a fixed-color edit. A separate
`w:docDefaults` fixture retains `accent1` plus shade through read and save.

## Verification

- Theme-linked direct-run and document-default contracts: 2/2.
- Full FreeW Core.IO package suite: 1451/1451.
