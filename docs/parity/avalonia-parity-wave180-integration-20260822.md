# Avalonia Parity Wave 180 Integration

Date: 2026-08-22
Base revision: `4ece471272`

## FreeX Name Box dropdown

The Avalonia Name Box popup now uses model-backed rows, an explicit popup
viewport, and a non-virtualizing items panel. The focused production-window
test shows and lays out the window, opens the popup, and verifies five realized
text descendants rather than only rereading the item models.

Integration also exposed an upstream command-id migration regression. The
shared ribbon now emits `pivot.chart.insert`, while Avalonia's contextual
command map still registered the removed `PivotChart` literal. The host now
uses `FreeXRibbonCommandIds.PivotChartInsert`, and the adjacent contextual
handler guard protects that canonical registration.

The focused FreeX lane passed 19/19 tests. The physical X11 Name Box selector
remains open: retained 1280x820 runs still report 0/8 because the application
capture is blank and the required object-state artifact is not produced. The
managed result is not substituted for a physical pass.

## FreeW Mark Index Entry

The Avalonia dialog now places the page-range radio and bookmark selector on
the same horizontal row as WPF and uses the WPF-aligned 220-DIP selector width.
Focused tests passed 7/7. Fresh WPF/Avalonia captures improved changed-pixel
ratios from 11.78% to 8.21% for initial state, 11.61% to 8.06% for populated
state, and 11.90% to 8.34% for validation state.

All three rows remain genuine visual mismatches. The canonical inventory stays
at 291 rows: 80 passes, 141 genuine visual mismatches, and 70 Avalonia
extensions.

## FreeP TTML style references

The shared transcript planner now resolves TTML style definitions, ordered
style references, chained inheritance, inline precedence, and malformed cycles.
The resolved shared span model carries foreground/background, font family and
size, weight/style, underline, opacity, voice, language, and supported layout
properties into both renderers.

Focused verification passed 31/31 shared planner tests, 1/1 Avalonia renderer
test, and 2/2 WPF renderer plus package round-trip tests. Remaining TTML model
extensions include line-through/overline combinations, outline/shadow, ruby,
and bidi-specific behavior.

## Claim boundary

Wave 180 advances one bounded slice in each application and repairs the
integration regression encountered on current main. It does not claim complete
functional or visual parity for any application.
