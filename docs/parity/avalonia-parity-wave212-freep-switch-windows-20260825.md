# FreeP Switch Windows parity — 2026-08-25

## Scope

FreeP now exposes **View > Window > Switch Windows** in both native ribbon profiles. Ink/Draw behavior and map-chart fidelity remain outside this visual-parity stream, as recorded in `ux-visual-parity-scope-2026-08-25.md`.

## Change

The command uses the existing native desktop window registry at invocation time. It opens a checked, native menu containing each visible FreeP document window; choosing an entry restores it only when minimized, then activates and focuses it. The current window stays checked.

This is intentionally a command-triggered native menu rather than an authored static ribbon dropdown: a static definition cannot correctly represent document windows created or closed after the ribbon has rendered.

## Dependency

None. The behavior uses the WPF `Application.Current.Windows` and Avalonia classic-desktop `Windows` collections already required by the existing Arrange All and Cascade Windows commands.

## Verification

The shared ribbon workflow test asserts the typed command route and both native hosts compile against the common action profile. A foreground capture should be added when the multi-window capture lane is available.
