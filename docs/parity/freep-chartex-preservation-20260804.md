# FreeP native ChartEx preservation

Date: 2026-08-04

FreeP now retains the native ChartEx series layout identifier in the chart
model and across slide cloning. ChartEx parts whose `cx:series/@layoutId` is
not `waterfall` are written back from their preserved native XML without
receiving waterfall-only connector or subtotal metadata.

The existing waterfall path remains editable: its connector-line state and
explicit total-point indices continue to be applied to the native ChartEx
`cx:layoutPr` on save. Unknown or not-yet-modeled ChartEx families retain
their native payload instead of being silently converted into a classic chart
or misclassified as waterfall.

Focused package coverage verifies content/relationship preservation, clone
state, and a non-waterfall `histogram` near-miss. The full FreeP host suite
passes 2,024/2,024 on the Release artifact.

This closes a functional save-back boundary; it does not claim live authoring
or renderer parity for every ChartEx family.
