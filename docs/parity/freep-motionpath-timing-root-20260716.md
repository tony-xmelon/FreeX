# FreeP Motion-Path Timing Root - 2026-07-16

## Scope

FreeP now emits the PowerPoint timing-root attributes required around the
slide animation tree: `dur="indefinite"`, `restart="never"`, `fill="hold"`,
and `nodeType="tmRoot"`. The existing main-sequence, trigger-sequence, and
motion-path child structure is unchanged.

## Evidence

- The round-tripped `10-motionpath.pptx` package previously omitted the
  `tmRoot` timing-node attributes even though the package passed Open XML
  schema validation.
- A PowerPoint COM open/save normalization produced the expected `tmRoot`
  node, confirming that this is a semantic PowerPoint compatibility contract.

## Verification

```text
dotnet test freep\FreeP.App.Presentation.Tests\FreeP.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~PptxRepairCorpusValidityTests" --logger "console;verbosity=normal"
dotnet test freep\FreeP.App.Host.Tests\FreeP.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~MotionPathFixtureTests|FullyQualifiedName~MotionPathModelTests" --logger "console;verbosity=minimal"
```
