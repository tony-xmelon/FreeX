# FreeW File-Format Honesty Proof

This slice keeps FreeW's File > Open, Save As, and Export truth in the shared presentation layer so the WPF and Avalonia shells stay thin consumers of the same plan.

## Proven contract

- `DocumentFormatCapabilityPlanner` describes catalog formats with explicit capability rows: normal Open/Save, template, legacy compatibility, import-only, and export-only.
- `FileFormatHonestyProof.BuildDefaultRows()` derives deterministic evidence rows from those capability rows. Tests cover macro preservation, template semantics, PDF import/export separation, compatibility feature-loss language, and native OOXML classification.
- `DocumentSaveCompatibilityPlanner` is the shared pre-write warning planner. Focused tests prove ordinary native OOXML targets do not warn, non-macro OOXML targets warn before dropping preserved VBA project bytes, `.docm`/`.dotm` preserve existing macro bytes, and RTF/ODT/OTT/legacy/plain-text targets warn before feature loss.
- WPF `FileCommands` and Avalonia `MainWindow` source guards verify both shells call `DocumentPersistenceWorkflow.BuildSaveCompatibilityPlan(...)` before writing bytes and render only the shared `DocumentSaveCompatibilityPlan`.

## Remaining caveat

The proof is source/catalog/planner-level. Real Word round-trip and visual baselines for compatibility formats such as RTF, ODT/OTT, legacy `.doc`/`.dot`, HTML/MHTML, Word 2003 XML, and plain text remain external fidelity evidence and are not claimed by this slice.
