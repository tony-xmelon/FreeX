# FreeW Mail Merge Story Discovery and Chart Text

## Gap

Mail merge could substitute ordinary run text, while field discovery and Check for Errors inspected only body run text plus a separate header/footer pass. Visible fields in text boxes, WordArt, SmartArt, ruby fragments, charts, grouped drawings, footnotes, endnotes, and comments could therefore execute without being validated. Chart title, axis-title, category-label, and series-name text was also deep-cloned but not substituted.

## Result

- `MailMerge.FieldNames(TextDocument)` now owns one deterministic traversal of every mergeable story and visible drawing-text surface.
- The traversal includes all section header/footer variants, annotation stories and comment replies, nested drawing groups, and every chart text surface.
- Plain and rule-aware record merges substitute chart title, category/value axis titles, categories, and series names, including charts nested in drawing groups.
- Check for Errors consumes the authoritative document scanner instead of maintaining a narrower duplicate header/footer traversal.

## Evidence

- Model contracts verify discovery order across body, shape, WordArt, chart, header, footnote, endnote, and comment stories.
- Model contracts verify all direct and grouped chart text is substituted without mutating the template.
- Planner contracts prove missing fields in shapes, charts, footnotes, and comments are reported.
- The rich-content DOCX contract writes and reopens substituted chart title, axis titles, category label, and series name.

This is functional and package parity work. It does not change chart rendering geometry or claim a visual-diff delta.
