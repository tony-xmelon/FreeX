# FreeW saveSubsetFonts settings parity

## Gap and selection

The requested settings audit found no typed reader/writer implementation for any of the eight candidates on
`origin/main`. `w:saveSubsetFonts` was selected because it completes FreeW's existing embedded-font package
contract: Word uses this document policy to request glyph subsetting when font embedding is enabled. The
[Open XML `SaveSubsetFonts` contract](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.wordprocessing.savesubsetfonts?view=openxml-3.0.1)
defines it as an `OnOffType` child of `w:settings`; omission means embedded fonts should not be subsetted.

## Model and package behavior

- `TextDocument.SaveSubsetFonts` defaults to `false` and survives compare, combine, mail merge, and ordinary
  body-command apply/revert paths.
- The reader accepts empty, `1`, `true`, and `on` as enabled and `0`, `false`, and `off` as disabled.
- The writer emits canonical `<w:saveSubsetFonts/>` only when enabled. It can author the policy without current
  font parts, and it overlays or removes a Word-authored value between `w:embedSystemFonts` and
  `w:saveFormsData` in `CT_Settings` order.
- FreeW does not create a font subset. Existing embedded bytes are de-obfuscated, retained exactly in the
  model, and re-obfuscated at the package boundary while the policy round-trips independently.

## Evidence

- `SaveSubsetFontsModelTests`: default/mutation plus compare, mail-merge, and body-command retention.
- `SaveSubsetFontsRoundTripTests`: exact authored XML, default omission, all seven on/off lexical forms,
  reopen and second-save stability, schema-position overlay, authoritative clearing with unknown-neighbor
  retention, Microsoft 365 schema validation (including background plus embedded-font ordering), and exact
  embedded-font byte retention through two saves.
- `dotnet test freew/FreeW.Core.Model.Tests/FreeW.Core.Model.Tests.csproj --configuration Release --filter FullyQualifiedName~SaveSubsetFonts`: 3/3 passed.
- `dotnet test freew/FreeW.Core.IO.Tests/FreeW.Core.IO.Tests.csproj --configuration Release --filter FullyQualifiedName~SaveSubsetFonts`: 12/12 passed.
