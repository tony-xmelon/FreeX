# Backstage visual contract, Wave 147

The shared shell now owns the Backstage values that are proven equivalent across the WPF and Avalonia realizers. `BackstageVisualContract` contains the shared primary/secondary text colors, pane heading/section/detail/action metrics, and frame rail/content/divider geometry. WPF and Avalonia translate those primitive values into their native control types.

This wave intentionally leaves app accents, pane-specific widths, planners, content factories, and control templates host-native. The focused WPF and Avalonia contract tests verify both realizations against the same neutral values.
