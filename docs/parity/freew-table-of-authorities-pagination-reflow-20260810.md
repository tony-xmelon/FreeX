# FreeW Table of Authorities Pagination Reflow

## Word contract

Table of Authorities page references describe the final laid-out document. Inserting a TOA before its
citations, or replacing a short generated region with a longer one, must account for the pages consumed by
that region in the same update action. A second manual refresh must not change the result.

## Previous gaps

- WPF and Avalonia resolved citation pages before changing the generated region, leaving page references one
  layout behind after insertion or replacement reflow.
- WPF citation-only paragraphs could not provide a live glyph rectangle because their hidden TA marker has
  zero ink. The paginator's authoritative block-page assignment was not used as a fallback.
- Avalonia's end-of-paragraph sentinel could search for a glyph that did not exist in a zero-ink paragraph,
  aborting relayout and discarding otherwise valid page evidence.
- WPF's private tab-leader element could not be cloned by `XamlWriter`, blocking pagination, print preview,
  and printing once a generated TOA contained visible page-reference leaders.

## Implementation

- Both hosts apply a provisional generated region and run a bounded fixed-point loop: relayout, resolve citation
  pages, and replace until generated style/text signatures stop changing, all inside one undo transaction.
- Failed stabilization rolls back every command already applied in the open transaction instead of leaving a
  partial generated region or an open undo batch.
- WPF falls back to `PaginationEngine.ComputeBlockPageAssignment` for zero-ink top-level citation hosts.
- Avalonia now places a caret sentinel at the current paragraph position when the paragraph has no glyphs.
- The WPF tab-leader visual is a public XAML-cloneable element carrying only its leader and brush paint state.
- Pagination failure does not invent page `1`; tests needing live page ownership run on the real headless UI
  compositor.

## Verification

- Insertion and replacement fixtures with eight citation-only paragraphs are stable after the first update in
  WPF and Avalonia; a second refresh produces identical entry text.
- The WPF fixture resolves the shifted citations on physical page 3; Avalonia resolves its measured fixture on
  page 2. Both results use each host's authoritative print/layout compositor at the same source page geometry.
- A WPF section-numbering control starts at physical label `IX` and stabilizes the shifted page as `XI`.
- Existing TOA options, field ownership, formatting, passim, explicit-break, table-pagination, update-fields,
  and command-routing tests remain covered.
- A direct WPF print clone contract preserves every tab leader's type, brush token, and width.
- `FreeW.App.Host.Tests`: focused TOA and print-clone lane passed 15/15.
- `FreeW.App.Avalonia.Tests`: focused TOA/update-fields lane passed 13/13.
- `FreeW.Core.Model.Tests`: `DocumentCommandBusTests` passed 35/35.
- `FreeW.App.Presentation.Tests`: `TableOfAuthoritiesRegionPlannerTests` passed 12/12.
- Repository preflight passed, including generated evidence and conflict-marker checks.
- `dotnet build FreeW.slnx --configuration Release --no-restore` completed with 0 warnings and 0 errors.
