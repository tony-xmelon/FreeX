# Avalonia Parity Wave 43

Date: 2026-07-28

## FreeX

The modal Avalonia Cell Styles gallery now uses the same guarded command path as
the WPF-equivalent ribbon and native-menu entries. Applying a preset therefore
honors opening/saving state and commits a pending formula edit before the
undoable style mutation, instead of bypassing those workflow guards.

Focused regression coverage: `CellStylesFunctionalParityTests`.
