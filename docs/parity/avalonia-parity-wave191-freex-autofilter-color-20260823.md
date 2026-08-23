# Avalonia Parity Wave 191: FreeX AutoFilter Fill Color

Date: 2026-08-23
Branch: `codex/parity-wave192-freex-20260823`
Source/image-build commit: `3541f35714`
Physical run: `20260823T144242Z`

## Result

The production Linux X11 lane proves **Filter by Cell Color** through the
rendered popup. It pixel-gated the green `#00B050` fill swatch, applied the
filter, saved, reopened through the identity-checked production Open picker,
and verified the same visible and semantic state after reopen.

Physical lane: **1 passed, 0 failed, 1 total**.

Exact postconditions:

- rendered swatch gate: before `#FFFFFF`, rendered `#00B050`, sample `(113,452)`, click `(139,456)`, button `(97,439,75,27)`
- applied visible values: `North,East,`
- clean save: `true`
- package: `ref=A1:B5|colId=0|cellColor=1|dxfId=0|fill=FF00B050`
- production reopen: `dialog-open=true`, `dialog-closed=true`
- reopened visible values: `North,East,`
- reopened semantic `A4`: `East`

The retained XLSX was parsed independently from `xl/worksheets/sheet1.xml`
and `xl/styles.xml`; it contains `filterColumn/colorFilter`,
`cellColor="1"`, and a DXF fill of `FF00B050`.

## Root Cause and Fix

The original loaded-XLSX cell-patch save path rewrote cell values and
dimensions, but only normalized existing AutoFilter XML. When a command added
modeled `FilterColumns` state, the patch package therefore retained
`<autoFilter>` while silently dropping the new `filterColumn/colorFilter`.

`XlsxFileAdapter.SourcePackageSnapshot` now re-emits only modeled AutoFilter
criteria after a patch save. Filter-owned hidden rows are an explicit dimension
patch concern, while unrelated dimension/view metadata stays under the existing
source sanitization and preservation rules. The fix is shared by fill and font
color save paths. The package test requires the real source-patch diagnostic,
opens the committed XLSX evidence, and asserts exact save/reload semantics.

## Verification

- Linux Docker fill lane: **1/1 passed** from source commit `3541f35714`.
- Fresh saved package: `cellColor=1`, `dxfId=0`, fill `FF00B050`.
- Core IO color/codec tests and Avalonia source/evidence guards are rerun with
  the Wave192 correction suite.
- App image: `freex-linux-interactive-app-freex-92b5f322f615:current`, digest
  `sha256:f252624586ad7f4ec6ddd50992111a5eecd05f36ee132359b8191dcffdd1662b`.

The evidence manifest records canonical-LF hashes for text, raw-byte hashes
for PNG/XLSX artifacts, and Git-blob audits for source provenance. It maps image
source `3541f35714` to byte-equivalent integration source `0fc47ab4d6`, evidence
commit `5205d4bc85`, and integration result `5743087e21`; guards verify those
blobs and ancestry directly through Git.
