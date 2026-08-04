# FreeW Page Setup Visual Parity, Wave 154

The Avalonia Page Setup dialog was captured against the WPF authority at 96 DPI and the same 560 x 600 logical capture size. The route covered the initial, populated, validation-error, Margins, Paper, and Layout states.

The production change keeps the shared planner, validation, focus, action semantics, and shared dialog chrome. It adds the WPF authority's measured tab widths and route-local action/launcher spacing where Avalonia's Linux Fluent measurements differed.

## Evidence

| State | Before changed ratio | After changed ratio | Delta | Before mean channel delta | After mean channel delta | Delta |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| initial | 0.100628 | 0.098985 | -0.001643 | 7.0570 | 6.9524 | -0.1046 |
| populated | 0.100628 | 0.098985 | -0.001643 | 7.0570 | 6.9524 | -0.1046 |
| validation-error | 0.101554 | 0.099911 | -0.001643 | 7.1736 | 7.0690 | -0.1046 |
| tab-margins | 0.100628 | 0.098985 | -0.001643 | 7.0570 | 6.9524 | -0.1046 |
| tab-paper | 0.045955 | 0.044467 | -0.001488 | 3.2872 | 3.1975 | -0.0897 |
| tab-layout | 0.074393 | 0.071935 | -0.002458 | 5.1717 | 5.0560 | -0.1157 |

All six states improved on both reported measures. The comparison classified all six as genuine visual mismatches because the harness still records platform text rasterization and native-frame differences; this slice reduces the route-owned geometry difference without replacing those platform effects with placeholders.

## Reproduction

The temporary capture subset used the harness's exact `--scenario` option for each route state. WPF and Avalonia were captured in serialized, isolated processes with single-node, disabled-build-server settings, then compared with the structured Page Setup subset inventory. The generated capture bundle is temporary and is intentionally not tracked.
