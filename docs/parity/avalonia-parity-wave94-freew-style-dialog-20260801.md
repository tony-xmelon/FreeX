# FreeW Style Dialog Parity Wave 94

Date: 2026-08-01
Base: `334d8f69c38bc0eec4ee75a5cb465576e90a088f`
Branch: `codex/agent-freew-style-dialog-wave94-20260801`

## Scope

This slice keeps the WPF Style dialog as the visual authority for the Avalonia New Style surface. The shared 21px compact metrics, five editor combos, three formatting checks, initial Name focus, and OK/Cancel default/cancel behavior remain unchanged.

The largest reusable mismatch in the paired captures was the combo-box chrome. WPF renders each field with a vertical `#F0F0F0` to `#E5E5E5` surface gradient, while Avalonia used a flat `#F0F0F0` fill. The Style dialog now supplies that gradient locally, plus WPF-authority `#ACACAC` input borders and `#707070` non-default button borders. Its action row has a one-pixel right correction to match the WPF client-frame capture without changing the outer `327x440` dialog size.

## Paired Evidence

Evidence root: `artifacts/wave94-style-dialog/`

| State | Before changed pixels | After changed pixels | Before ratio | After ratio |
| --- | ---: | ---: | ---: | ---: |
| initial | 16,579 | 11,154 | 11.523% | 7.752% |
| populated | 16,795 | 11,348 | 11.673% | 7.887% |
| validation-error | 16,579 | 11,154 | 11.523% | 7.752% |

The capture tool reported `327x440` for both WPF and Avalonia in all three rows. The paired semantics retained five combo boxes, three checks, default `OK`, cancel `Cancel`, and Name as the initial focus target. The full comparison reports and heatmaps are in `compare-*-after2/` under the evidence root; the pre-change reports are in `compare-*`.

## Tests

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~PasteStyleDialogParityTests --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
  - 5 passed.
- `freew/FreeW.App.Presentation.Tests/StyleDialogPlannerTests.cs` already covers empty-name validation, formatting mapping, and style-list ordering; it was not changed in this visual-only slice.

## Residuals

The harness's `validation-error` Style row currently clears the Name field but does not submit the modal WPF prompt, because WPF validation opens a blocking warning dialog rather than an inline status control. Consequently that row is intentionally the same visual state as the initial row; the planner's empty-name rejection remains covered by the existing focused planner test. Typography and native text rasterization still account for the remaining pixel delta.
