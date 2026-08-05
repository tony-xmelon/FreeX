# FreeW File-Format Honesty Proof

This slice keeps FreeW's File > Open, Save As, and Export truth in the shared presentation layer so the WPF and Avalonia shells stay thin consumers of the same plan.

## Proven contract

- `DocumentFormatCapabilityPlanner` describes catalog formats with explicit capability rows: normal Open/Save, template, legacy compatibility, import-only, and export-only.
- `FileFormatHonestyProof.BuildDefaultRows()` derives deterministic evidence rows from those capability rows. Tests cover macro preservation, template semantics, PDF import/export separation, compatibility feature-loss language for RTF, ODT/OTT, Word 2003 XML, HTML/MHTML, legacy `.doc`/`.dot`, and plain text, plus native OOXML classification.
- `DocumentSaveCompatibilityPlanner` is the shared pre-write warning planner. Focused tests prove ordinary native OOXML targets do not warn, non-macro OOXML targets warn before dropping preserved VBA project bytes, `.docm`/`.dotm` preserve existing macro bytes, and RTF/ODT/OTT/legacy/plain-text/web/WordML targets warn before feature loss.
- Focused Core.IO round-trip/package tests now provide deterministic stream evidence beyond catalog rows: RTF writes RTF control words and reloads its modeled text/table subset, ODT and OTT write valid ODF packages and reload text, HTML and MHTML write reloadable web/archive bytes, Flat OPC and WordML write their distinct XML roots and reload modeled text, legacy `.doc` writes an OLE/CFB container and reloads text, and plain text writes paragraph characters plus tab-delimited table rows while dropping formatting and unsupported structures by design.
- WPF `FileCommands` and Avalonia `MainWindow` source guards verify both shells call `DocumentPersistenceWorkflow.BuildSaveCompatibilityPlan(...)` before writing bytes and render only the shared `DocumentSaveCompatibilityPlan`.

## Remaining caveat

This proof is deterministic FreeW IO/planner evidence, not an MS Word visual baseline. Real Word round-trip comparison, pagination, and pixel parity for compatibility formats such as RTF, ODT/OTT, legacy `.doc`/`.dot`, HTML/MHTML, Word XML/WordML, and plain text remain external fidelity evidence and are not claimed by this slice.
