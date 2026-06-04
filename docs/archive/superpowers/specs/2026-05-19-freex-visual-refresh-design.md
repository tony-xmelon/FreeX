# FreeX Visual Refresh Design

## Goal

Give FreeX a consistent, readable Excel-aligned visual language across the title bar, quick access toolbar, ribbon tabs, generated command buttons, backstage, sheet tabs, and status bar.

## Direction

Use an Excel-aligned minimal system rather than a brand clone. The app should keep Excel's familiar structure and command meaning while using FreeX's own restrained palette, shared resource dictionaries, and reusable glyph language.

## Visual System

Create shared WPF resources for core colors, typography, borders, hover states, and glyph treatment. Use white and soft gray surfaces, near-black text, and a restrained green accent for selected tabs, active controls, and workbook identity.

## Icon Language

Prefer compact, readable glyphs that convey the same meaning as Excel ribbon buttons. Keep text labels where ribbon scanability depends on them. Replace the most inconsistent quick access glyphs and generated command glyphs with shared font choices and predictable fallbacks.

## Implementation Boundaries

Keep behavior unchanged. Avoid broad layout rewrites. Touch the visual layer, command presentation planner, and focused source-hygiene tests only.

## Verification

Use source-level tests to guard resource wiring and glyph cleanup. Use a WPF build to verify XAML validity.
