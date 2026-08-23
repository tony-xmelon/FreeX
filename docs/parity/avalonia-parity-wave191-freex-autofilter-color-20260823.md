# Avalonia Parity Wave 191: FreeX AutoFilter Fill Color

Date: 2026-08-23
Branch: `codex/parity-wave191-freex-20260823`
Run: `20260823T124634Z`

## Result

Closed one physical Linux AutoFilter color workflow at the WPF/Excel package authority: Filter by Cell Color using the rendered green fill swatch, save, production Open, and exact rendered/semantic/package readback.

Physical lane: 1 passed, 0 failed, 1 total.

Exact postconditions:

- rendered menu swatch gate: sample `(113,452)` changed from `#FFFFFF` to `#00B050`; sample and click `(139,456)` are inside button `(97,439,75,27)`
- applied visible values: `North,East,`
- clean save: `true`
- package: `ref=A1:B5|colId=0|cellColor=1|dxfId=0|fill=FF00B050`
- production reopen: `dialog-open=true`, `dialog-closed=true`
- reopened visible values: `North,East,`
- reopened semantic `A4`: `East`

The saved XLSX is retained in the evidence bundle so the XML package can be independently inspected. The lane used real X11 pointer/keyboard input against the packaged Avalonia FreeX application in Docker; no synthetic-only or formula-bar-only result was credited.

## Implementation

`XlsxAutoFilterXmlCodec` now writes `cellColor="1"` explicitly for fill-color filters and `cellColor="0"` for font-color filters, matching Excel/WPF OOXML authority. The physical harness adds the deterministic green/yellow/no-fill fixture, a pixel-gated rendered swatch click, package parser, and identity-checked production reopen. Criteria is derived only after the rendered menu pixel passes; the runner independently requires the swatch-gate artifact and the exact package/semantic postconditions.

## Verification

- Core IO color persistence tests: 8 passed, 0 failed.
- Avalonia physical-lane source/hash tests: 4 passed, 0 failed.
- Presentation color planner/workflow tests: 30 passed, 0 failed.
- Linux Docker physical lane: 1 passed, 0 failed.
- App image: `sha256:a4c04d475c05e4697d75847c7f5991a215697ba7087d17bf8fc8958402def90b`.

Source and harness provenance is recorded in [manifest.json](evidence/wave191-freex-autofilter-color-20260823/manifest.json). The bundle includes the fixture, saved XLSX, physical result, swatch gate, postcondition, reopen diagnostics, and four rendered captures, all retained and hash-listed.

## Provenance Audit Follow-up

The first evidence record was incomplete: its four PNGs were ignored locally, `commitAtRun` pointed at base `9bd76f7f...`, and its command used `-SkipImageBuild`. That record did not prove that the app image contained the committed Wave191 product change.

The later integration hash divergence came from checkout-dependent line endings. The worker tree retained a mix of LF and CRLF bytes under global `core.autocrlf=true`, while Git blobs and a fresh integration checkout normalized different subsets. Wave191 text entries now declare `hashMode=canonical-lf`: strict UTF-8 is normalized only from CRLF or lone CR to LF before SHA-256. PNG and XLSX entries declare `hashMode=raw` and remain byte-exact. The `eol=lf` attributes keep future checkouts stable, while the canonical policy also validates pre-existing Windows worktrees without refreshing them. The source tests cover LF/CRLF/CR equivalence, raw-byte inequality, every manifest artifact, and every provenance path.

The strengthened physical lane was rerun from clean source commit `97d114b4c0d63c464a4dd151ae94905ae15789d1` with no `-SkipImageBuild` or `-SkipPublish`. The runner published and built app image `freex-linux-interactive-app-freex-15bded1b2789:current` with digest `sha256:a4c04d475c05e4697d75847c7f5991a215697ba7087d17bf8fc8958402def90b` from Ubuntu base digest `sha256:89446b2863db602caf7a869e3aad7358ec31c4c7842d70d2e17f0127fe76e824`. The manifest records the exact LF checkout hashes for the final harness, runner, fixture generator, source test, product source, product test, fresh run command, and every retained file.

## Remaining Color Gaps

This wave closes fill-color apply/save/reopen. A separate physical Linux lane still remains for font-color swatch apply/save/reopen, and no physical lane here claims No Fill or apply/change/clear sequencing. Shared/core support and focused tests cover those command paths, but they remain uncredited as physical WPF/Excel-authority workflows until exercised through the rendered Avalonia surface.
