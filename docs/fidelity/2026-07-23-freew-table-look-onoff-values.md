# Table Look On/Off Value Compatibility

FreeW now accepts every common WordprocessingML `ST_OnOff` lexical spelling for `w:tblLook` flags: `1`/`0`, `true`/`false`, and `on`/`off`.

This covers the first/last row and column style flags plus the inverted horizontal and vertical banding flags. Existing absent-attribute behavior is retained, while saved packages use FreeW's canonical numeric form. The regression exercises hand-authored non-numeric values, verifies the resulting table formatting, serialized attributes, and reopen behavior.
