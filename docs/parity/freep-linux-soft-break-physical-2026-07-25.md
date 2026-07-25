# FreeP Linux physical rich-text soft-break lane

Suite: `freep-linux-rich-text-shortcut-physical`
Surface: `in-canvas-rich-text-soft-break`
Category: `physical-x11-rich-text-shortcut`
Evidence: `physical-x11-input`
Baseline: `false`

This lane uses `tools/FreeP.RenderCompare/corpus/21-comments-notes.pptx`, the proven owner geometry and 16:9 shape ID2 center calibration. It physically enters the in-canvas editor, replaces text with ASCII `SoftBefore`, sends Shift+Enter, enters `SoftAfter`, commits naturally, and saves. Package checkpoints must prove one native paragraph with ordered text, `a:br`, text and zero picture or graphic-frame fallbacks. Ctrl+Z restores the exact original text; Ctrl+Shift+Z restores the soft break.

The host contract is pending in the probe and is marked passed only by the PowerShell runner after strict five-row order, physical evidence, basename-only nonempty artifacts, schema, and source/mount hash checks. Defaults are 1280x820, 96 dpi, 4g, port 6095, artifact root `artifacts/freep-rich-text`; the container stops unless `KeepContainer` is requested.

Calibration risk is retained in geometry, screenshots, window state, package copies, and JSON inspections: window chrome, DPI, pane width, or fixture layout changes can move the physical pointer away from shape ID2.
