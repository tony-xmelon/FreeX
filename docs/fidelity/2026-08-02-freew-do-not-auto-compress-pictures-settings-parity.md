# FreeW doNotAutoCompressPictures settings parity

## Scope

FreeW now models WordprocessingML's document-level `w:doNotAutoCompressPictures` save policy. When
enabled, consuming applications must retain embedded picture data rather than automatically recompressing
images during save. The setting is independent of individual picture geometry and formatting.

The contract is defined by Microsoft's Open XML SDK documentation for
[`DoNotAutoCompressPictures`](https://learn.microsoft.com/en-us/dotnet/api/documentformat.openxml.wordprocessing.donotautocompresspictures):
it is an `OnOffType`, is serialized as `w:doNotAutoCompressPictures`, and defaults to allowing compression
when omitted.

## Model and package behavior

- `TextDocument.DoNotAutoCompressPictures` defaults to `false`.
- The reader accepts the complete `ST_OnOff` lexical set: an empty element, `1`, `true`, and `on` enable the
  policy; `0`, `false`, and `off` disable it.
- The writer emits the canonical non-default form `<w:doNotAutoCompressPictures/>` and omits the default
  form.
- Reopened documents preserve the policy and a second save produces stable settings XML.
- Compare, combine, and mail-merge clone paths retain the document save policy; ordinary undoable body
  commands do not disturb it.
- Preserved unknown settings remain intact. The overlay inserts the element in `CT_Settings` order after
  `w:doNotIncludeSubdocsInStats` and before `w:forceUpgrade`.

## Verification

Focused model tests cover the default, explicit enablement, clone-style document operations, and command
apply/revert retention. Focused package tests cover exact XML, all seven on/off representations, reopened
state, second-save stability, neighboring unknown settings, canonical removal of the default, and Open XML
SDK schema validation at the Microsoft 365 conformance level.
