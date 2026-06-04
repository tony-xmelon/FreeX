# Rotation Dialog Normalization Parity

## Goal

Align the drawing Rotation dialog with the command layer and Excel-style object rotation fields by normalizing accepted degrees into a single 0-through-359 full-turn range.

## Completed

- [x] Normalize `RotationDialog.TryParseRotation` results so values such as `450` and `-90` resolve to `90` and `270`.
- [x] Keep non-finite input rejected through the existing numeric parser.
- [x] Add focused dialog parser coverage for positive, negative, and full-turn values.

## Verification

- `dotnet test tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~ObjectDialogTests.RotationDialog" -v:minimal`
