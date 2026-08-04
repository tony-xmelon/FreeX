# FreeW section page vertical alignment parity (2026-08-04)

## Scope

WordprocessingML section `w:vAlign` already round-tripped through `PageSettings.VerticalAlignment`,
but the WPF page surface and composite evidence renderer always placed body content at the top.
WPF page boxes now consume Center and Bottom alignment directly. The evidence renderer measures the
unused space below the final paragraph line and translates only the final body page, where Word also
applies the remaining section space.

Top remains unchanged. Justified remains on the top-flow path because Word distributes unused space
between paragraphs; a whole-body translation would not model that behavior.

## Provenance

- Word 16 `ExportAsFixedFormat` from isolated, visible COM instances, followed by the repository PDF
  rasterizer at 816x1056.
- FreeW Release `FreeW.FidelityRender --composite`, rebuilt after the source change.
- Word readiness, document-open, export, close, and owned-process quit completed without prompts.
- Minimal one-line package hashes:
  - Center: `BC671287E99CDE0EDBABDEE7ACDEFDFF29BA1F8E31C05C4740AE9516B68C50C7`
  - Bottom: `794675480C1D00D9E74EA1A5157DF27593DD910D1C88B703FB6E900949C7FDB2`

## Evidence

Mean absolute RGB channel difference, expressed as a percentage of 255:

| Fixture | Alignment | Whole before | Whole after |
|---|---|---:|---:|
| Minimal one-line | Center | 0.1766% | 0.0611% |
| Minimal one-line | Bottom | 0.1646% | 0.0761% |
| Realistic comments page | Center | 7.9544% | 3.3180% |
| Realistic comments page | Bottom | 8.6089% | 2.7581% |

Minimal body ink registration moved from Y `100..113` to `517..530` for Center and `934..947`
for Bottom. Word is `516..530` and `933..947`, respectively: both candidates are within one pixel.

The three-page header/footer control confirmed page ownership:

| Alignment/page | Whole before | Whole after |
|---|---:|---:|
| Center 1 | 5.0770% | 5.0770% |
| Center 2 | 5.8936% | 5.8936% |
| Center 3 | 5.2723% | 3.6810% |
| Bottom 1 | 7.2174% | 7.2174% |
| Bottom 2 | 5.8423% | 5.8423% |
| Bottom 3 | 5.7827% | 3.0429% |

Pages 1 and 2 have no spare body space and stayed byte-stable. Only the final page moved and both
Center and Bottom improved materially. A separate top-aligned table control also remained SHA-256
byte-identical (`AC280FCEA0B71E0C025F8F3EE3A20CE058A150D306A0DEC29952B91FCDD5F647`).

## Verification

- `PageVerticalAlignmentPlannerTests`: 5/5.
- `PageVerticalAlignmentHostTests` plus the FidelityRender source contract: 5/5.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Fresh Word COM exports: 6/6 probe documents.
- Fresh FreeW composite renders: complete one-page and three-page sequences.

## Process rule

Recover section vertical placement from measured body free space, not a fixed page offset. Gate a
minimal registration probe, a realistic body page, and the complete affected page sequence; require
full pages and top-aligned controls to remain byte-stable. Keep Justified as a separate paragraph-
distribution problem.
