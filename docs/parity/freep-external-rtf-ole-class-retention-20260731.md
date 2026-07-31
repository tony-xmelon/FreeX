# FreeP external RTF OLE class retention - 2026-07-31

External RTF paste already preserved embedded object bytes and inserted them as editable OLE
shapes in both WPF and Avalonia, but the source `\\objclass` token was discarded before insertion.
That caused uncommon or versioned Office objects to be recreated with the filename-derived
generic `Package` progId.

The shared clipboard payload now carries the optional source OLE class through serialization,
both host clipboard adapters pass it to `EditingSession.InsertEmbeddedObject`, and
`OleInsertionPlanner` uses it as the emitted `p:oleObj/@progId` when present. Existing internal
file insertion and legacy clipboard payloads retain the filename-derived metadata path.

Focused coverage proves Word `Word.Document.12` survives parser and clipboard round-trip, a
custom `Vendor.Custom.Widget.7` class becomes the emitted progId, and the existing Office-file
metadata tests remain unchanged. This is a functional/package-authority slice; no renderer or
PowerPoint visual-baseline claim is made.
