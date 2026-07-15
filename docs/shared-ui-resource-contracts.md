# Shared UI Resource Contracts

The shared WPF chrome consumes neutral `ThemeNeutral*Brush` resources projected by
`WpfThemeApplier`. `SharedChromeResources.xaml` keeps literal neutral fallbacks because WPF cannot
load a `DynamicResource` reference as a standalone resource-dictionary value before a visual owner
exists. Replacing those values with runtime references causes XAML load-time failures rather than a
late-bound theme lookup.

`Free.Shared.Theme.Tests` treats `BrandThemes` as authoritative and verifies every neutral fallback
literal, while `RibbonVisualPalette.FromTheme` remains the framework-neutral projection for shared
ribbon rendering. The contract tests are the drift guard for these projections.
