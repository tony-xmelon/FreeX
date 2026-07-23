# Table Row CantSplit Toggle Retention

FreeW now reads `w:trPr/w:cantSplit` using the WordprocessingML on/off semantics. An empty token still prevents the row from splitting across pages, while an explicit `w:val="0"` permits splitting.

The writer already emits `w:cantSplit` only for a disabled `AllowBreakAcrossPages` setting, so an imported explicit-off token now canonicalizes to omission on save without changing its effective behavior. The package regression uses a hand-authored Word-valid row property, verifies the read state, saved XML, and reopened model.
