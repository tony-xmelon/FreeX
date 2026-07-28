# FreeP imported hierarchy3 cache authority

## Scope

An imported `hierarchy3` SmartArt graphic can contain both parsed `data1.xml`
nodes and a PowerPoint-generated `dsp:drawing` cache. The bounded live hierarchy
planner is useful for authoring, but it does not reproduce the imported
PowerPoint geometry closely enough to replace that cache automatically.

The reader now keeps the cached drawing authoritative when the imported package
contains fallback shapes. Authoring and explicit layout-change paths still clear
the fallback and re-enable the live planner after regenerating the cache.

## Evidence

Fresh `14-smartart-live.pptx` comparison at 1280x720, using the current Release
`FreeP.RenderCompare` consumer and the local PowerPoint COM export:

| Measure | Current main | Candidate |
|---|---:|---:|
| WPF slide 2 mean channel delta | 11.7450% | 1.1567% |
| WPF four-slide average | 3.6979% | 1.0508% |
| Avalonia four-slide average | 0.8972% | 1.0816% |

The other three WPF slides were unchanged. The candidate remains a functional
source-authority fix; it makes no claim of native PowerPoint raster identity.

## Verification

- Presentation SmartArt tests: 290/290 no-build.
- WPF SmartArt host tests: 206/206 no-build.
- Avalonia SmartArt host tests: 20/20 compile-first and 20/20 no-build.
- Focused imported-cache tests passed compile-first and no-build in Presentation
  and WPF host projects.
- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
