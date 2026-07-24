# FreeP SmartArt Authoring Tail 3 - 2026-07-24

This slice exposes two additional SmartArt layouts that already have live reader and
shared-renderer support but were missing from the authoring surface:

- `verticalBulletList`
- `titledMatrix`

Each layout now has a shared authoring preset, localized WPF/Avalonia ribbon command,
native diagram-layout ID, and the existing undoable editing-session route. The change
reuses the existing hierarchy/matrix live layout families and does not claim exact
PowerPoint polygon, bullet, title, or spacing geometry.

## Verification

- Generated command inventory: 240 total, 238 shared, 0 actionable host gaps
- Shared planner layout matrix covers both native IDs and families
- WPF host persistence and native package reread cover both layouts
- Avalonia headless command registration covers both layouts
