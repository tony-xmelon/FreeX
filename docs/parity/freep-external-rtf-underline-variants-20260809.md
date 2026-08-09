# FreeP external RTF underline variants - 2026-08-09

## Scope

Word and other RTF producers can encode visible underline semantics with more
than the plain `\\ul` control word. The shared reader previously recognized
only `\\ul`/`\\ul0`, so double, wave, dashed, and related underline variants
were imported as unformatted text even though the FreeP run model already
supports `Run.Underline`.

## Implemented

The RTF reader now normalizes the supported stroke-specific underline control
words (`\\uldb`, `\\uld`, `\\ulw`, dashed/thick variants, and wave variants)
to the existing shared underline flag. The writer continues to emit the
canonical `\\ul` form, so the semantic survives a shared clipboard round-trip
without inventing a provider-specific stroke model.

## Verification

- `ExternalRichTextClipboardTests.RtfUnderlineVariants_NormalizeToSharedUnderlineSemantics`: 1/1.
- Full `ExternalRichTextClipboardTests`: 63/63.
- The change is in the shared planner consumed by both WPF and Avalonia; host
  clipboard gates remain to be rerun after the consuming host artifacts rebuild.

## Boundary

The exact underline stroke pattern is intentionally not claimed. This slice
preserves the visible on/off semantic already represented by the model; richer
provider-specific RTF stroke rendering remains outside the bounded model.
