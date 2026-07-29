# FreeP Chart Protection Authoring - 2026-07-30

FreeP now exposes the four native PowerPoint chart protection flags through the
shared editor path in both WPF and Avalonia:

- chart object protection;
- chart data protection;
- chart formatting protection;
- chart selection protection.

Each option has three states: automatic/omitted, protected, and explicitly
unprotected. The shared command changes all four flags as one undoable operation,
including the ability to clear an imported protection state. Existing
`c:chartSpace/c:protection` reader/writer behavior remains authoritative for
package output and preserves explicit false values.

Verification:

- chart planner and command tests: 3/3;
- chart command plus package metadata tests: 72/72;
- WPF chart/dialog tests: 145/145;
- Avalonia protection/dialog tests: 3/3;
- ribbon definition tests: 27/27;
- WPF and Avalonia Release builds: 0 warnings, 0 errors.

This is a functional/package parity slice. It makes no new raster-fidelity claim.
