# FreeP Animation Command Selection Guard

Date: 2026-07-26

Animation effect commands now require a selected shape before reporting success. Previously the shared planner returned success even though `EditingSession.AddAnimation` correctly ignored the request when no shape was selected, producing a false command result and no corresponding undo state.

Evidence: the focused no-selection regression passes, and the existing animation planner suite remains covered. This is a functional command-contract fix; it adds no visual animation claim.
