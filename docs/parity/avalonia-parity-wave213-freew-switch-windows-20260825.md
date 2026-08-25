# FreeW Switch Windows parity — 2026-08-25

## Scope

FreeW now exposes **View > Window > Switch Windows** in its WPF and Avalonia ribbon profiles. Ink/Draw behavior and map-chart fidelity remain outside the current visual-parity stream, per `ux-visual-parity-scope-2026-08-25.md`.

## Change

The command builds a native menu from the current visible FreeW document windows when invoked. The active window is checked. Selecting a different window restores it only when minimized, then activates and focuses it.

The menu is intentionally host-owned and dynamic: document windows are created and closed after the static ribbon definition has already rendered.

## Dependency

None. The WPF and Avalonia hosts use their existing desktop window collections, which already back FreeW New Window and Arrange All.

## Verification

Shared View workflow tests cover command registration and host routing. WPF and Avalonia host builds validate their native menu implementations.
