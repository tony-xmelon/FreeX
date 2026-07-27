# FreeP SmartArt Chevron Process Live Layout Evidence - 2026-07-07

This slice admits PowerPoint `chevronProcess` diagrams into the bounded FreeP
SmartArt process-family live layout path.

## Scope

- `PptxPackageReader` marks `chevronProcess` as live-layout supported.
- The implementation stays in shared FreeP core/presentation layers.
- WPF and Avalonia consume the same shared Chevron slide-shape draw ops.
- No renderer-local SmartArt policy is added.

## Honesty Bound

`chevronProcess` uses the bounded shared chevron-process planner: ordered stage
text becomes left-to-right `Chevron` preset shapes using the shared 24% notch and
76% interlocking step,
so the shared compositor emits the same polygon geometry for WPF and Avalonia.
Unsupported, malformed, or out-of-bound input still falls back to cached drawing.

This is not an exact PowerPoint visual baseline: PowerPoint-authoritative
chevron metrics, effects, and pixel captures remain deferred because no COM
baseline is available in this environment.

The 24% notch and `adj=24000` are grounded in the shared `Chevron` geometry
builder and its DrawingML 0..100000 guide convention; the 76% advance is the
complementary interlocking step. The checked-in corpus does not provide a
separate authoritative geometry for the basic or closed variants.

## Evidence

- `SmartArtLayoutTests` proves `chevronProcess` produces live process boxes and
  connectors, and that cached drawing is bypassed only for the supported layout.
- `SmartArtTests` proves the PPTX reader enables live layout for
  `chevronProcess`, keeps another process sibling on cached fallback, and emits
  shared connector draw ops consumed by both hosts.
