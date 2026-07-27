# Avalonia Parity Wave 40

Date: 2026-07-28

## Closed Production Slices

### FreeX

Avalonia inline note editing now shares the platform-neutral comment-preview
placement planner used by the WPF adapter. The popup clamps to the viewport,
tracks its worksheet anchor, dismisses when the anchor leaves the viewport,
places the caret at the end of existing note text, and uses WPF-equivalent
foreground sizing and spacing.

Verification:

- Shared placement planner tests: **5/5 passed**.
- WPF placement adapter tests: **8/8 passed**.
- Avalonia inline review runtime tests: **8/8 passed**.

### FreeW

Avalonia now renders all fourteen WPF artistic picture effects plus shadow,
glow, soft edge, bevel, and reflection presets 1 through 5. Shadow and glow
use expanded rasters while retaining the original image rectangle for layout,
hit testing, grouping, header/footer rendering, and reflection placement.
Pencil Sketch follows the WPF blend and saturation pipeline, and blur no longer
allocates a channel array per pixel.

Verification:

- Avalonia picture parity tests: **34/34 passed**.
- Avalonia floating-image tests: **24/24 passed**.
- WPF image-adjust authority tests: **12/12 passed**.
- Full Avalonia suite: **1,362 passed, 3 pre-existing baseline failures**.

### FreeP

Linux slideshow recording now discovers V4L2 camera devices, validates an
FFmpeg software MP4 encoder, records 1280x720 video at 30 fps, and exposes
camera and narration through one composite capture backend. Narration and
camera share one lifecycle implementation for child-process ownership,
completion, cancellation, disposal, output validation, and temporary cleanup.

Verification:

- Linux recording tests: **42/42 passed**.
- Avalonia camera wiring tests: **2/2 passed**.
- WPF camera authority test: **1/1 passed**.
- Whole-window evidence manifest regenerated with **170 artifacts** and no
  generated drift.

## Residuals

- FreeX note placement and styling still need a paired foreground WPF/Avalonia
  capture for pixel-level sign-off.
- FreeW picture effects still need paired Windows/Linux screenshots; exact
  compositor anti-aliasing, blur, and opacity-mask pixels are renderer-owned.
- FreeP camera discovery and command planning are covered, but physical Linux
  capture remains unproven because the Docker harness has no `/dev/video*`
  device attached.
- The broader whole-app parity goal remains active. Generated command and
  dialog route coverage does not replace interactive workflow and authoritative
  visual validation.
