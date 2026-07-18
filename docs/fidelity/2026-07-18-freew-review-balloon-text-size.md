# FreeW Review Balloon Text Size

## Scope

The WPF fidelity composite renders Word's review-markup page surface for
documents with visible comments. Its Arial balloon body text was one DIP too
small, leaving the first long comment one line short relative to Word.

The review-bubble `FormattedText` size is now 8 DIPs. Page scaling, strip
geometry, balloon anchors, colours, body content, and comment ownership remain
unchanged.

## Matched Word Evidence

Persistent Word COM baseline: `f2-comments.docx`, page 1, at 816x1056.

| Region | Before | After |
| --- | ---: | ---: |
| Whole page | 3.0382% | 3.0353% |
| Comment strip and balloons `(555,255)-(816,337)` | 14.9781% | 14.8699% |

The first balloon now receives its Word-like additional text line. The
comments-only protection fixture was freshly rendered on the same Release
artifact; its Word comparison remains valid at 2.4339%.

## Verification

- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Fresh composite renders: `f2-comments` pages 1-2 and
  `review-protection-proofing-comments-only` page 1.
