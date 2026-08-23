# Avalonia Parity Wave 192: FreeX AutoFilter Font Color

Date: 2026-08-23
Branch: `codex/parity-wave192-freex-20260823`
Source/image-build commit: `3541f35714`
Physical run: `20260823T144853Z`

## Result

The production Linux X11 lane proves **Filter by Font Color** through the
rendered popup. It pixel-gated the green `#00B050` font swatch, applied the
filter, saved, reopened through the identity-checked production Open picker,
and verified the same visible and semantic state after reopen.

Physical lane: **1 passed, 0 failed, 1 total**.

Exact postconditions:

- rendered swatch gate: before `#FFFFFF`, rendered `#00B050`, sample `(113,452)`, click `(139,456)`, button `(97,439,75,27)`
- applied visible values: `North,East,`
- clean save: `true`
- package: `ref=A1:B5|colId=0|cellColor=0|dxfId=0|font=FF00B050`
- production reopen: `dialog-open=true`, `dialog-closed=true`
- reopened visible values: `North,East,`
- reopened semantic `A4`: `East`

The retained XLSX was parsed independently from `xl/worksheets/sheet1.xml`
and `xl/styles.xml`; it contains `filterColumn/colorFilter`,
`cellColor="0"`, and a DXF font color of `FF00B050`.

## Root Cause and Fix

Independent review found the prior retained font package contained only an
`<autoFilter>` element and no color criterion or green DXF. The production
workflow exposed a real save bug: the loaded-XLSX cell-patch save path did not
re-emit newly modeled AutoFilter criteria after patching cells, so visible
in-memory state could be lost in the saved package.

`XlsxFileAdapter.SourcePackageSnapshot` now re-emits independent worksheet
metadata, including modeled AutoFilter criteria, after the patch save. The
cross-platform package test opens both committed evidence packages, asserts
their exact XML semantics, applies fill/font commands to their fixtures, saves,
reloads, and asserts the semantics again.

## Verification

- Linux Docker font lane: **1/1 passed** from source commit `3541f35714`.
- Fresh saved package: `cellColor=0`, `dxfId=0`, font `FF00B050`.
- The companion Linux Docker fill lane also passed **1/1** from the same
  committed source.
- Core IO color/codec tests, package semantic tests, and source/evidence guards
  are rerun with this correction.
- App image: `freex-linux-interactive-app-freex-92b5f322f615:current`, digest
  `sha256:6e3770905926290378060ef9b24ba97e649028e832efa0c29f80401a69243743`.
- Docker base image digest: `sha256:139480d3bbefee9deb69dde84a035bd378da35b96cdb38126bc2a8d8a51e814a`.

The evidence manifest records canonical-LF hashes for text, raw-byte hashes
for PNG/XLSX artifacts, and Git-blob audits for source provenance.
