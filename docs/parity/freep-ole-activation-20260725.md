# FreeP OLE Activation Function Slice

FreeP already preserves embedded OLE package bytes, ProgId, relationships, and fallback preview
images. This slice exposes the missing user-facing activation path: selecting one OLE shape and
invoking **Open Embedded Object** now routes the preserved payload through the existing
`OleActivationService` in both WPF and Avalonia. The service writes a temporary file with the
resolved extension and delegates to the operating system's registered host application.

The shared command is `freep.object.open-embedded`. Empty payloads remain a safe no-op, and the
WPF registry exposes a callback seam so tests verify payload identity without launching an
external application. Nested group selection uses the existing recursive shape lookup.

When the registered host exits, the activation session now reads back a non-empty changed
temporary file into the same mutable `OleObjectInfo` and deletes the temporary file. This makes
external Excel, Word, or PowerPoint edits persist through the normal FreeP save path without
terminating or otherwise controlling the external host process. Unchanged and empty results are
discarded.

Verification includes the WPF payload-routing test, Avalonia command registration and definition
tests, localization coverage, OLE service tests, and the generated command parity inventory
(286 total commands, 284 shared by both hosts, 0 actionable host gaps).
