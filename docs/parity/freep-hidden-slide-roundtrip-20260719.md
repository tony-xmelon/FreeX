# FreeP hidden-slide round-trip parity - 2026-07-19

## Scope

PresentationML uses `p:sld/@show` to mark a slide hidden from slideshow
presentation. FreeP previously ignored that attribute on read and omitted it
on write, so any modeled edit silently made hidden slides visible.

## Change

`Slide.IsHidden` now preserves the semantic state. The reader accepts both
OOXML boolean forms (`show="0"` and `show="false"`), while the writer emits
canonical `show="0"` only for hidden slides. Visible slides remain unchanged
when the attribute is omitted or explicitly true.

## Verification

- `HiddenSlides_RoundTripShowAttributeWithoutSynthesizingVisibleState`: `1/1`
- `PptxPackageRetentionTests`: `49/49`
- `FreeP.App.Host.Tests` Release build: `0` warnings, `0` errors

The test mutates a four-slide package with hidden, explicit-visible, and
omitted-visible forms, then verifies the serialized XML and reopened model.
