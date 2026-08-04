# FreeP Avalonia Parity Wave 147: Authored Accent Process

Date: 2026-08-04

Authored `AccentProcess` now emits a deterministic main/accent `dgm:pt`
topology, uses the shared `LayoutAccentProcess` plan for its two visual roles
and `N - 1` transitions, and preserves the native `accentProcess` identity
through PPTX writer/reader round-trip. WPF and Avalonia remain thin
`SlideCompositor` consumers.

The reader admits only the exact authored topology with the deterministic cache
signature emitted by FreeP's writer. Imported PowerPoint Accent Process
drawings and richer or changed role grammars remain on cached fallback. This
slice does not claim PowerPoint-pixel geometry, native effects, or broader
SmartArt parity.
