# FreeW Native NOTEREF Complex Fields

FreeW now refreshes generic Word `NOTEREF` fields carried by `w:fldChar` / `w:instrText`, including the
`\p` above/below switch. The model delegates note-marker lookup and numbering to the existing
cross-reference resolver, while WPF and Avalonia pass only the owning run index needed for exact relative
position text. Unsupported or dangling note targets retain their cached result.

Focused coverage includes model recomputation, DOCX complex-field round-trip, and both host `UpdateFields`
paths. Full solution and UI verification remain deferred while another Wave 168 build is active.
