# FreeW Update Index identifier dialog parity

## Scope

Alternate indexes can now be refreshed from References > Update Index in both FreeW hosts. The existing
Insert Index dialog is reused in an explicit update mode with **Update Index** title and **Update** action,
while the renderer-neutral planner continues to normalize blank input to the default index and trim an
alternate identifier.

WPF prompts in the loaded application and calls `RefreshIndex(result.Identifier)`; its detached registry
contract retains a non-modal default refresh. Avalonia uses an owner-modal callback and retains the same
default refresh fallback when the callback is absent. Cancel leaves all generated regions unchanged.

## Verification

- Shared index options planner: 6/6.
- WPF index options dialog: 3/3.
- WPF References/Index registry contract: 1/1.
- Avalonia complete `ReferencesTabTests`: 80/80.
- Index model and DOCX complex-field control suites remain green.
- WPF and Avalonia Release host builds: 0 warnings, 0 errors.

The selective Avalonia test creates default and `People` generated regions, adds a new `People` XE mark,
updates `People`, and proves the default region is unchanged. Its paired fallback test adds both default and
`People` marks, invokes callback-free Update Index, and proves only the default region changes.

## Remaining index scope

Durable Word `INDEX` field ownership and Word's index layout choices remain separate model/package/layout
slices. The full default/alternate authoring, insertion, and selective-update workflow is now reachable from
both user interfaces.
