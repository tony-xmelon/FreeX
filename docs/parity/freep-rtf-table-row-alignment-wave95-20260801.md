# FreeP RTF Table Row Alignment, Wave 95

FreeP now preserves the bounded RTF row-alignment controls `\\trql`, `\\trqc`,
and `\\trqr` for nested inline tables. The shared `TableRow` model records left,
center, or right placement; omitted controls remain the existing left-default.

The value survives table cloning/equality checks and the recursive rich clipboard
codec. WPF consumes it through the inline table editor, including row-relative
offsets for rows with narrower cell geometry. Avalonia uses the same model through
its inline-table horizontal-offset planner, so nested table placement is derived
from the containing visual width rather than a renderer-specific semantic fork.

Focused coverage verifies nested outer/inner RTF parsing, explicit left and omitted
defaults, recursive clipboard serialization, clone/equality behavior, WPF placement,
and Avalonia left/center/right offsets. Full native Word table-layout fidelity,
complex mixed-width row geometry, and provider-specific RTF controls remain deferred.
