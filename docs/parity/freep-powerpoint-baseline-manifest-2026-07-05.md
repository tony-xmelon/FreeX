# FreeP PowerPoint Baseline Manifest - 2026-07-05

## Scope

This slice turns the remaining PowerPoint-authoritative render baseline debt into an executable manifest and verifier. It does not create or check in any new PowerPoint PNGs.

## Evidence Path

- `tools/FreeP.RenderCompare --corpus-summary tools/FreeP.RenderCompare/corpus --manifest <out.json>` writes a JSON manifest with every corpus deck, expected slide count, tracked reference PNG count, reference status, and the local `PowerPoint.Application` COM prerequisite state.
- `--require-complete-refs` turns the summary into a verifier that fails when any deck is missing PowerPoint reference PNGs.
- `--allow-missing-powerpoint` is an explicit local guard: when `PowerPoint.Application` COM is unavailable, missing reference PNGs are reported in the manifest and the verifier can pass as skipped-with-reason. On a COM-capable machine, missing references still fail.

## Local Command

```powershell
dotnet run --project tools\FreeP.RenderCompare\FreeP.RenderCompare.csproj --configuration Release -- --corpus-summary tools\FreeP.RenderCompare\corpus --manifest artifacts\freep-powerpoint-baseline-manifest.json --require-complete-refs --allow-missing-powerpoint
```

## Current Status

All 27 corpus decks now have tracked PowerPoint references: `53/53` slide PNGs.
The former ten-slide `15-smartart-grouped-list` gap was captured at 1280x720
through `PowerPoint.Application` COM on 2026-08-16 and then re-exported through
the isolated validator with `10/10` matching reference hashes. The committed
baseline metadata is `docs/parity/freep-powerpoint-baseline-2026-08-14.json`.

The remaining work is visual comparison and renderer tuning against these
references; complete corpus coverage alone is not a full PowerPoint visual-parity
claim.
