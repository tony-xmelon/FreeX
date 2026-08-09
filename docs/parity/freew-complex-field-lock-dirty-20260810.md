# FreeW complex-field lock and dirty parity

## Scope

- Preserve `w:fldLock` and `w:dirty` from the outer begin character of complex Word fields.
- Keep the metadata distinct from self-contained `w:fldSimple` metadata.
- Emit the attributes only on the outer begin `w:fldChar` and omit false/default values.
- Honor complex-field locks in WPF and Avalonia Update Fields while leaving unlocked fields updateable.
- Preserve the same metadata for complex fields spanning multiple paragraphs.

## Verification contract

- Direct paragraph and content-control reader paths import both attributes.
- Save and reopen preserve both attributes and cached results.
- Separate/end markers do not receive begin-only attributes.
- WPF and Avalonia retain a locked STYLEREF cache while recomputing an adjacent unlocked control.

## Out of scope

- Nested complex-field hierarchy remains represented by the existing flattened field model.
- Dirty fields are preserved as authored; FreeW does not automatically force a refresh solely because
  `w:dirty` is present.
