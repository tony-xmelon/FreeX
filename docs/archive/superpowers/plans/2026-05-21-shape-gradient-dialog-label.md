# Shape Gradient Dialog Label

## Goal

Improve keyboard navigation in the Shape Gradient dialog by associating the RGB override text box with a targeted access-key label.

## Scope

- Add a source assertion for the RGB override label target.
- Replace the passive `RGB override:` caption with `RGB _override:` targeting the gradient input.
- Keep color picker behavior and gradient parsing unchanged.

## Verification

- Red: focused Shape Gradient label test fails before implementation.
- Green: focused Shape Gradient/Hyperlink tests pass after implementation.
- Run `git diff --check` before commit.
