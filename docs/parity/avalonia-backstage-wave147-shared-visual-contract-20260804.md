# Backstage visual contract, Wave 147

The shared shell now owns the Backstage values that are proven equivalent across the WPF and Avalonia realizers. `BackstageVisualContract` contains the shared primary/secondary text colors, pane heading/section/detail/action metrics, and frame rail/content/divider geometry. WPF and Avalonia translate those primitive values into their native control types.

This wave intentionally leaves app accents, pane-specific widths, planners, content factories, and control templates host-native. The focused WPF and Avalonia contract tests verify both realizations against the same neutral values.

A fresh paired `backstage-open.open` render at `560x600` passed WPF and
Avalonia size/content gates. Changed ratio improved from `0.128074` to
`0.107369`, mean absolute channel delta from `11.262` to `9.245`, and pHash
distance from `6` to `4`. The route remains classified as a genuine visual
mismatch. Because the Open pane includes persisted recent-file content, the
comparison is useful directional evidence rather than a fully controlled
commit-only A/B.
