# FreeW TOA empty-result and passim semantics

Date: 2026-08-06

## Word calibration

Live Word COM established two narrow behavioral contracts:

- A specific category with no marked entries updates to exactly
  `No table of authorities entries found.`
- `\p` uses distinct page references. Five marks on one page render page `1`; five marks on five pages
  render `passim`.

The source model now emits a native run-level TOA field for an empty filtered category and bases passim
on the already deduplicated physical-page list whenever pagination evidence is available.

## Exact product-package gates

Three FreeW-authored packages were opened and updated in Word:

```text
empty-statutes.docx
SHA-256 5C9C2B85408B84F5EC5FEFCC9A253AF53EA29EB533811C3595836A06A62D2427
before/after: No table of authorities entries found.

passim-same-page.docx
SHA-256 846C4F9ED7140A7214AC9F7925532BB4B14DA17A0355E70CC924F2262F444AEB
before/after: Cases | Case A<TAB>1

passim-five-pages.docx
SHA-256 43C768F2494752DA11346B73E017F8B3FA2450254A16A41222CA9B4DA1DDA991
before/after: Cases | Case A<TAB>passim
```

All three used Word-recognized native `TOA` objects, updated without changing the expected result, and
left no `WINWORD` process.

## Verification

- Shared model TOA tests: 47/47.
- Package TOA round-trip tests: 9/9.
- WPF host distinct-page passim contract: 1/1.
- Avalonia host distinct-page passim contract: 1/1.

## Process rule

Do not derive page semantics from raw mark counts. Canonicalize aliases, deduplicate physical pages,
then apply page-count thresholds. Empty native fields also need a retained owner/result so imported
options survive save, reopen, and refresh.
