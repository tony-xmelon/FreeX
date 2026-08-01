# FreeW page-border display and z-order package parity

## Gap

FreeW already retained a page border's edge geometry, style, color, offset, spacing, and decorative-art id,
but it dropped the section-level `w:pgBorders/@w:display` and `@w:zOrder` attributes. Opening and saving a
Word document could therefore turn a first-page-only or not-first-page border into an all-pages border and
move a behind-text border in front of document content.

## Implementation

- `PageBorder.Display` models `allPages`, `firstPage`, and `notFirstPage`.
- `PageBorder.ZOrder` models `front` and `behind`.
- The reader preserves both attributes and applies Word's all-pages/front defaults when they are absent.
- The writer emits only non-default values, matching Word's canonical omission behavior.

The semantic model is intentionally separate from renderer calibration. This slice prevents package data
loss; page-index filtering and behind-text composition are follow-up visual-owner work.

## Verification

- Exact `word/document.xml` assertions cover omitted defaults and canonical non-default tokens.
- Reopened-model assertions cover first-page and behind-text values.
- A mutated WordprocessingML fixture covers not-first-page plus behind-text import.

Schema references:

- [Microsoft Learn: PageBorders](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.wordprocessing.pageborders?view=openxml-2.20.0)
- [Microsoft Learn: PageBorderDisplayValues](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.wordprocessing.pageborderdisplayvalues?view=openxml-3.0.1)
