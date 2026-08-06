# FreeW native bibliography field ownership

Date: 2026-08-06

## Scope

FreeW generated bibliography content as styled paragraphs inside a bibliography building-block wrapper,
but the generated entries had no native `BIBLIOGRAPHY` field owner. Word could display the cache but could
not update the generated region as a bibliography field.

Generated entries now carry Word's native ` BIBLIOGRAPHY \l 1033 ` ownership. The visible heading stays
outside the field, matching Word's update boundary. Multi-entry results use FreeW's spanning-field model;
the one-paragraph empty result uses a run-level complex field.

## Word calibration

Direct Word automation established these contracts:

- Updating ` BIBLIOGRAPHY \l 1033 ` over a document with three sources replaces a multi-paragraph result
  while retaining one native field owner.
- A document with no sources has the exact cached result
  `There are no sources in the current document.`
- The generated field owns entries only; the bibliography heading is outside its begin/end boundary.

The final FreeW-authored `references-heavy-fields.docx` had SHA-256
`E10DF0D16377141319F1B74439BDF181EDF9AA408615EC1EBF00639C5CCC81FA`. Word found both the fixture's
standalone cache field and the generated bibliography field, updated the generated field successfully,
and saved SHA-256 `F2408D8D4093BEFF3C06D04881EF5082E5AE9A81B9E293AC028FC433D5808B8A`.

The empty Word calibration package had SHA-256
`AAA6E8D17F2F976CE9BE6E5B3A6004734515F8FA2F84F2C1CEF4CBFE37B235F9`.

## Verification

- `CitationsTests`: 96/96.
- `BibliographyRoundTripTests`: 35/35.
- `BibliographyRegionPlannerTests`: 5/5.
- WPF bibliography insertion owner contract: 1/1.
- Avalonia bibliography insertion owner contract: 1/1.
- Related block-content-control package contracts: 45/45 during the rejected ID probe.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.

## Rejected probe

A generated `w:id` was added to all block content controls to test whether Word would expose the special
bibliography SDT through `Document.ContentControls`. The collection remained empty, and shared second-save
tests exposed canonical ordering risk. The broad writer change was reverted; acceptance rests on Word's
recognized and updateable bibliography field, not that COM collection.

## Process rule

For generated Word reference regions, retain separate semantic owners: the gallery/content-control wrapper,
the visible heading, and the native field result. A package token is accepted only when Word recognizes and
updates that exact field owner; a broad metadata probe with no effective COM-path change is diagnostic only.
