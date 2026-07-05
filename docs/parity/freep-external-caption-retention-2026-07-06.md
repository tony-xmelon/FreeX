# FreeP External Caption Retention - 2026-07-06

## Scope

This slice tightens shared PPTX package retention for PowerPoint media caption
relationships that use `TargetMode="External"`. The behavior lives in shared
OPC/PPTX IO and model metadata, so both WPF and Avalonia consume the same
caption contract without renderer-specific code.

## Improved

- OPC relationship target projections now preserve whether the source
  relationship used `TargetMode="External"`.
- Media caption loading treats `TargetMode="External"` as authoritative, even
  when the target string is relative rather than an absolute URI.
- External caption tracks remain link metadata with no caption bytes, no
  generated VTT sidecar, and no FreeP recording artifact manifest.
- Saved slide XML emits `p20media:caption r:link` for external tracks and the
  slide relationship keeps `TargetMode="External"`.

## Verification

- `dotnet test freep\FreeP.App.Host.Tests\FreeP.App.Host.Tests.csproj --configuration Release --no-restore --disable-build-servers --filter FullyQualifiedName~MediaFieldsTests -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`

## Remaining

- Broader PowerPoint-native media/caption baselines still need more captured
  package variants.
- Real OS microphone/camera capture implementations remain separate workflow
  depth work.
