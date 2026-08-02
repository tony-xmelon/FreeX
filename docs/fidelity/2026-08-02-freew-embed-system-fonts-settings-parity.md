# FreeW `w:embedSystemFonts` settings parity

Date: 2026-08-02

## Scope

FreeW now models Word's positive `w:embedSystemFonts` policy: when font embedding is enabled,
consumers should include common system fonts. Absence remains the default. The policy is retained
even when the current package has no font parts because it governs later embedding saves.

## Package behavior

- The reader accepts omitted, `1`/`0`, `true`/`false`, and `on`/`off` forms.
- The writer emits the canonical empty element only when enabled and removes an authored value when
  the model disables it.
- `embedTrueTypeFonts`, `embedSystemFonts`, and `saveSubsetFonts` retain CT_Settings schema order.
- Reopen and second-save output is stable, while existing embedded font bytes remain unchanged.
- Compare, combine, and mail merge retain the policy.

FreeW does not manufacture common-system-font parts; it preserves the Word save policy and any
embedded font payload already present in the package.
