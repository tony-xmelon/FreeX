# FreeP soft-edge pass-density probe rejected - 2026-07-18

## Scope

The imported `08-effects.pptx` soft-edge shape carries a 101600 EMU radius
(10.67 DIP). FreeP's shared shape-effect planner approximates the edge with
concentric fill-colored pen passes. A bounded probe changed the pass rule from
the accepted six-pass `ceil(radius / 2)` cap to ten passes for this radius.

## Matched evidence

Fresh current Release renders were compared with the same PowerPoint COM PNG at
1280x720:

| Host | Accepted baseline | Ten-pass probe |
| --- | ---: | ---: |
| WPF whole page | 1.3797% | 1.4377% |
| Avalonia vs PowerPoint | 1.4705% | 1.5288% |

The candidate worsened both hosts and was reverted. The no-op eight-pass probe
was also discarded because the existing radius formula still produced six
passes, so it was path evidence rather than a fidelity candidate.

## Conclusion

Soft-edge residuals cannot be accepted from pass density alone. The accepted
six-pass planner remains in place; a future improvement needs a PowerPoint-
matching blur/alpha composition model, not a broader ring count.

## Verification

- FreeP RenderCompare Release build succeeded for both probe artifacts.
- WPF and Avalonia candidate renders completed successfully.
- Source was restored to the accepted planner before handoff.
