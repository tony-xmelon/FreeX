# Wave195 Cross-App Integration

Wave 195 contains three app slices: one FreeX slice, one FreeW slice, and one FreeP slice. Cumulative accounting is 585 app slices, 195 per app. The overall Avalonia/WPF 100% parity goal remains incomplete.

## FreeX

The authoritative physical evidence is `docs/parity/evidence/wave195-freex-autofilter-criteria-workflows-20260828/manifest.json`. Two production Docker/X11 sessions pass: multi-column AutoFilter criteria change/clear persistence and color criteria change/clear persistence. The manifest contains 75 listed artifacts, including 58 screenshots, and both sessions have reload witnesses. This is bounded physical FreeX Avalonia Linux X11 evidence for the named fixtures and retained sessions, not exhaustive parity or WPF evidence.

## FreeW

The canonical catalog remains 291 rows: 80 pass, 141 genuine visual mismatches, and 70 Avalonia extensions. Six Legal Notices states improve aggregate changed pixels from 324936 to 324253, a delta of -683. The other 285 non-Legal rows remain structurally unchanged.

## FreeP

The whole-window catalog is 36 pass and 0 mismatch. Combined rendered evidence is 64/64 pass and 0 mismatch. Wave195 rich-text selection evidence uses exact 251x74 crops and improves changed-pixel ratio from 0.2185757 to 0.1809518682, with mean channel delta 9.7919313736 and pHash distance 11. The native Office deck17 slide02 residual remains unresolved.

## Integration Status

Wave195 integration gates are pending until the parent runs them. This note records no Release-build, default-lane, repository-preflight, or integration-review timings or passing results. Wave194's accepted gate result is retained only as historical context in the generated dashboard.
