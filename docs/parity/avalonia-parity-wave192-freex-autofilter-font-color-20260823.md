# Avalonia Parity Wave 192: FreeX AutoFilter Font Color

Date: 2026-08-23
Branch: `codex/parity-wave192-freex-20260823`
Image-build source commit: `e165bc84a9cf207194247f1095e6d3579bc907c6`

## Result

The production Linux X11 AutoFilter persistence lane now proves **Filter by
Font Color** through the rendered popup. It pixel-gated the green `#00B050`
font swatch before clicking inside its measured button, applied the filter,
saved, reopened through the identity-checked production Open picker, and
verified the same visible and semantic state after reopen.

Physical lane: **1 passed, 0 failed, 1 total**.

Exact postconditions:

- rendered swatch gate: before `#FFFFFF`, rendered `#00B050`, sample `(113,452)`, click `(139,456)`, button `(97,439,75,27)`
- applied visible values: `North,East,`
- clean save: `true`
- package: `ref=A1:B5|colId=0|cellColor=0|dxfId=0|font=FF00B050`
- production reopen: `dialog-open=true`, `dialog-closed=true`
- reopened visible values: `North,East,`
- reopened semantic `A4`: `East`

The package parser independently reads `xl/worksheets/sheet1.xml`, resolves
the saved `dxfId` into `xl/styles.xml`, requires `cellColor="0"`, and requires
the DXF font color. The criteria string is produced only by the rendered-pixel
gate; a coordinate click without the gate cannot credit the result.

## Implementation

Wave191's color probe is now a shared fill/font workflow. Wave192 adds the
font-color selector, deterministic green-font fixture, font-mode DXF parser,
identity-checked reopen postcondition, and source/evidence guards. The
production font-color command and allocator were already correct and are
covered by the focused R89 tests, so no speculative product change was made.
Wave191 fill behavior remains on its original selector and call path.

Evidence and provenance are retained under
`docs/parity/evidence/wave192-freex-autofilter-font-color-20260823/`.

## Verification

- Focused FreeX Core IO color/codec tests: **16/16 passed**.
- Wave191 and Wave192 source/evidence guards: **8/8 passed**.
- Physical Linux Docker lane: **1/1 passed**.
- App image: `freex-linux-interactive-app-freex-92b5f322f615:current`, digest `sha256:81bde7c6d5fdd20391500d63f072c2a23b5bbea145640f661e1a8e57ac0a65e1`.
- Docker base image digest: `sha256:42786d247531ef93985d0a893e90d76f2b23c342178f8c47702c9dd58ddc12eb`.

The evidence manifest records canonical-LF SHA-256 for text and exact raw-byte
SHA-256 for PNG/XLSX artifacts. The final audit compares those hashes with
Git-blob content and validates the declared cross-platform checkout policy.

## Remaining Color Gaps

This wave closes physical font-color apply/save/reopen and preserves the
Wave191 fill-color lane. Physical No Fill, color-filter change/clear sequencing,
mixed-type columns, and multi-column color criteria remain outside the credited
physical evidence. Shared command, planner, codec, and focused tests cover
their existing paths, but they still need rendered Linux X11 evidence for
WPF/Excel-authority credit.
