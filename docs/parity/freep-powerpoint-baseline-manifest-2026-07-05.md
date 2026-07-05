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

## Remaining Gaps

- Generate the missing `tools/FreeP.RenderCompare/corpus/pptx-ref/<deck>/slide-*.png` baselines on a machine with desktop Microsoft PowerPoint COM registered.
- Re-run the verifier without relying on the missing-COM skip once references are complete.
- Continue full WPF/Avalonia/PowerPoint diff runs after all corpus references are present.
