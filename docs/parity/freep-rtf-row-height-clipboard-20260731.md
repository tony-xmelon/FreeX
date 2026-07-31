# FreeP RTF table row-height clipboard parity

The rich-text RTF parser now preserves the signed `\\trrh` row-height control for
nested inline tables. Positive values become an `AtLeast` constraint, negative values
become an `Exact` constraint using the absolute twips value, and zero remains automatic.

The constraint is part of the shared `TableRow` model, clone/equality paths, and inline
clipboard codec. WPF uses an automatic row with `MinHeight` for `AtLeast` and a fixed row
for `Exact`; Avalonia retains the same shared row metadata and authored height in its
inline-table visual plan. Existing slide-table rows without this optional rich-text rule
keep their prior behavior.

Focused coverage verifies signed nested-row parsing and codec retention. Advanced RTF
table controls outside row height remain deferred.
