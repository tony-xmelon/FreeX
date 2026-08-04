# Avalonia Parity Wave 145: Shared Dialog Action Labels

Date: 2026-08-04

The shared WPF and Avalonia dialog factories now consume one `ShellStringText`
contract for mnemonic escaping, display text, and accelerator lookup. This keeps
`Save __As` as visible `Save _As` without registering `Alt+A`, while `_Apply` still
registers `Alt+A`. Avalonia action-button tests inspect mnemonic text, display text,
automation name, and access-key metadata through the shared
`AvaloniaActionLabelInspector`, avoiding framework-specific `Content.ToString()`
assertions. FreeW files were not changed.
