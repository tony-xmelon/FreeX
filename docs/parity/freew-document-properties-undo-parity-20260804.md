# FreeW Document Properties Undo Parity

## Gap

Both FreeW Document Properties dialogs edited the live `DocumentProperties` object directly. WPF then
marked the file dirty and Avalonia relied on its shell workflow, but neither edit entered the document
command history. The five visible metadata fields could not be undone or redone.

## Resolution

- `DocumentPropertiesDialogValues` is the shared normalized payload for Title, Author, Subject,
  Keywords, and Comments.
- `ApplyDocumentPropertiesCommand` applies those five fields as one reversible edit while preserving
  hidden core metadata such as Category and Created.
- The WPF and Avalonia dialogs now return the payload without mutating the document.
- Both editor hosts execute the shared command through their existing document command bus.

## Verification

- Shared command: 1/1 passed, including apply, undo, redo, normalization, and hidden-metadata retention.
- WPF: 2/2 passed, covering the live editor undo route and a cross-host source ownership guard.
- Avalonia: 2/2 passed, covering the live editor undo route and the non-mutating dialog payload.
- All three focused groups passed again with `--no-build` against the compiled Release artifacts.

No Word COM or visual baseline is required for this functional editing-history slice.
