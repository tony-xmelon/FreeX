# FreeX Wave 69: Open Name Box Dropdown Pair

Date: 2026-07-30
Scope: FreeX WPF/Avalonia parity capture and comparison tooling only.

## Contract

The open Name Box dropdown is now a paired surface with the stable id `popup.nameBoxDropdown` and kind `overlay`.
Both authoritative images use a fixed `208x136` pixel frame. The pair contract fails closed when either side is
missing, uncaptured, misclassified, mis-sized, absent on disk, undecodable, uniformly white/transparent, or does not
carry the exact platform provenance required below.

The WPF capture opens the production `CellAddressBox` ComboBox after calling the existing screenshot-tour fixture
authority, renders the actual popup child, and records provenance `wpf-production-popup-render-target`. The fixture
contains the named range `Sales` and the four deterministic object entries:

- `Tour Name Box Chart`
- `Tour Name Box Picture`
- `Tour Name Box Shape`
- `Tour Name Box Text Box`

The managed Avalonia parity capture still opens the production popup as a diagnostic, but records `captured:false`
with provenance `managed-popup-diagnostic` and emits no PNG. It cannot pass the pair contract. The former hard-coded
StackPanel/TextBlock reconstruction has been removed.

Authoritative Avalonia evidence comes only from the dedicated `name-box-dropdown-parity` Docker/X11 physical selector.
That lane starts the app with the separate `680...` fixture, records visible X11 windows before and after opening the
production popup, and requires exactly one newly visible native popup window. It crops `208x136` pixels from the root
screenshot at that window's X11 coordinates without resizing and records provenance `native-x11-root-crop`.

The native manifest includes the root screenshot path, geometry JSON path, source bounds, crop bounds, fixed frame
size, and expected five-item fixture. The comparison contract reopens the geometry JSON and rejects disagreement
between it and the surface manifest. The Wave68 physical-selection fixture and its `670...` object ids are unchanged.

## Parent Physical Command

Run the native Avalonia capture from the integration checkout:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools\Run-FreeXLinuxInteractionValidation.ps1 `
  -PhysicalOnly `
  -PhysicalProbeSelector name-box-dropdown-parity `
  -Port 6082
```

The command prints the timestamped report directory under
`artifacts/linux-interactive/freex/interaction-validation/`. Authoritative comparison input is:

```text
<report>\x11-validation\name-box-dropdown-parity-native\manifest.json
<report>\x11-validation\name-box-dropdown-parity-native\popup.nameBoxDropdown.png
<report>\x11-validation\name-box-dropdown-parity-native\name-box-dropdown-parity-open-root.png
<report>\x11-validation\name-box-dropdown-parity-native\name-box-dropdown-parity-native.json
<report>\x11-validation\name-box-dropdown-parity-native\name-box-dropdown-parity-before-x11.txt
<report>\x11-validation\name-box-dropdown-parity-native\name-box-dropdown-parity-open-x11.txt
```

Capture the focused WPF authority from the same integration commit:

```powershell
dotnet run --project src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release -- `
  --parity-capture artifacts\wave69-namebox-wpf-native `
  --parity-capture-target popup.nameBoxDropdown
```

Then create the one-surface paired report:

```powershell
dotnet run --project tools\FreeX.ParityCompare\FreeX.ParityCompare.csproj --configuration Release -- `
  --skip-capture `
  --win-dir artifacts\wave69-namebox-wpf-native `
  --lin-dir <report>\x11-validation\name-box-dropdown-parity-native `
  --out artifacts\wave69-namebox-native-pair
```

The comparer rejects the managed Avalonia manifest and any missing/mismatched native provenance before evaluating
pixel differences.

## Verification

- Managed Avalonia guard: diagnostic only, `captured:false`, no PNG.
- Pair contract: accepts only WPF production-popup provenance plus Avalonia native-X11-root-crop provenance.
- Native source guard: requires one new X11 window, a no-resize `208x136` crop, geometry evidence, and nonblank PNG.
- Wrapper guard: validates all native fields and PNG header dimensions before copying the comparison directory.

Docker/X11 physical execution and final image inspection remain with the parent integration lane. No visual pass or
pixel-diff percentage is claimed until that command produces and a reviewer inspects a fresh native pair.
