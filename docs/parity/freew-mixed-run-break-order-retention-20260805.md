# FreeW mixed-run break order retention

## Gap

Microsoft Word can serialize text, a manual break, and following text as children of
one `w:r`. FreeW detected page and column breaks by type before reading all text, so
`before, break, after` reopened as `break, beforeafter`. Ordinary `w:br` and `w:cr`
children were also omitted from regular run text.

## Slice

- Stream ordinary run children in their authored XML order.
- Split one imported run into text and explicit page/column-break model runs only at
  the corresponding `w:br` child.
- Preserve formatting, revision, hyperlink, comment, and content-control ownership on
  every resulting fragment.
- Retain text-wrapping `w:br`/`w:cr` as embedded newlines and write embedded newlines
  back as canonical `w:br` elements.

## Evidence

Exact package tests construct a single bold Word run containing `before`, either a
page or column break, and `after`. They assert imported model order, saved XML child
order, and reopened model order. A paired line-break test covers an ordinary `w:br`
beside a soft hyphen and proves both positions survive save/reopen.

## Process rule

For mixed-content OOXML owners, preserve child order before normalizing physical
containers. Element presence alone is insufficient when pagination or visible text
depends on where the element occurs.
