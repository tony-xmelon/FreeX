# Avalonia Parity Wave 191: FreeX AutoFilter Fill Color

Date: 2026-08-23
Branch: `codex/parity-wave191-freex-20260823`
Run: `20260823T120957Z`

## Result

Closed one physical Linux AutoFilter color workflow at the WPF/Excel package authority: Filter by Cell Color using the rendered green fill swatch, save, production Open, and exact rendered/semantic/package readback.

Physical lane: 1 passed, 0 failed, 1 total.

Exact postconditions:

- rendered menu swatch: `#00B050`
- applied visible values: `North,East,`
- clean save: `true`
- package: `ref=A1:B5|colId=0|cellColor=1|dxfId=0|fill=FF00B050`
- production reopen: `dialog-open=true`, `dialog-closed=true`
- reopened visible values: `North,East,`
- reopened semantic `A4`: `East`

The saved XLSX is retained in the evidence bundle so the XML package can be independently inspected. The lane used real X11 pointer/keyboard input against the packaged Avalonia FreeX application in Docker; no synthetic-only or formula-bar-only result was credited.

## Implementation

`XlsxAutoFilterXmlCodec` now writes `cellColor="1"` explicitly for fill-color filters and `cellColor="0"` for font-color filters, matching Excel/WPF OOXML authority. The physical harness adds the deterministic green/yellow/no-fill fixture, rendered swatch coordinate, package parser, and identity-checked production reopen. The runner and source test register the bounded lane.

## Verification

- Core IO color persistence tests: 8 passed, 0 failed.
- Avalonia physical-lane source tests: 2 passed, 0 failed.
- Presentation color planner/workflow tests: 30 passed, 0 failed.
- Linux Docker physical lane: 1 passed, 0 failed.
- App image: `sha256:08c4378b7d9b42e8a134fdbf766f85a1cb62debefe18b292b51ae3acc87a2773`.

Source and harness provenance is recorded in [manifest.json](evidence/wave191-freex-autofilter-color-20260823/manifest.json). The bundle includes the fixture, saved XLSX, physical result, postcondition, reopen diagnostics, and four rendered captures.

## Remaining Color Gaps

This wave closes fill-color apply/save/reopen. A separate physical Linux lane still remains for font-color swatch apply/save/reopen, and no physical lane here claims No Fill or apply/change/clear sequencing. Shared/core support and focused tests cover those command paths, but they remain uncredited as physical WPF/Excel-authority workflows until exercised through the rendered Avalonia surface.
