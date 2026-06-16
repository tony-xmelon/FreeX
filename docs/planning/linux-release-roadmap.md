# Linux Release Roadmap: Toward Windows-Comparable

**Last updated:** 2026-06-16

**Goal:** reach a Linux release comparable to the Windows (WPF) FreeX app — a versioned,
published, trustworthy Linux build with feature coverage, quality, and accessibility close
enough to the Windows tester release to stand on its own.

This builds on [multiplatform-linux-port.md](multiplatform-linux-port.md) (the port
foundation: Avalonia shell, freedesktop packaging, hosted CI lane, readiness tooling). The
Linux app shares the same Avalonia shell as the macOS preview, so the feature gaps below are
largely shared with macOS and tracked against the WPF baseline.

## What "comparable to the Windows app" means

The Windows app ships through `tester-release.yml` / `Publish-UserTestBuild.ps1`: versioned
GitHub release assets (single-file / folder / MSIX), checksums, release notes, and a
public-preview promotion gated on accessibility evidence. Comparable on Linux means:

1. A **published, versioned Linux release channel** (tarball + AppImage, later distro
   packages) with checksums, notes, and a promotion gate.
2. **Feature coverage** close to the WPF app for the common spreadsheet workflows.
3. **Quality + fidelity** parity (XLSX round-trip, recalc) — already shared via the portable
   core; verify on Linux.
4. **Accessibility** evidence on real Linux desktops (keyboard-only, AT-SPI/Orca), X11 + Wayland.

## Status of the foundation

- Portable core + shared services: build and run on Linux. *(done)*
- Avalonia shell: publishes self-contained `linux-x64`/`linux-arm64`; native apphost. *(done)*
- Packaging: `.desktop`, MIME, icon, tarball+installer, AppImage. *(done)*
- Hosted CI lane (`linux-app.yml`, manual dispatch): build, tests, package, headless +
  Xvfb GUI smoke, aggregate readiness. *(first hosted run validating)*
- Readiness tooling + guard tests. *(done)*

## Phases

### Phase R1 — Linux release channel (infra)

- `linux-release.yml` (`workflow_dispatch`): versioned `linux-x64`/`linux-arm64` tarballs +
  AppImages, checksums, release notes, manifest; publish as GitHub release assets.
- `tools/Test-LinuxPublicPreviewPromotion.ps1`: promotion gate combining artifact readiness
  (`Test-LinuxPublicPreviewReadiness.ps1`) with accessibility-evidence inputs, mirroring the
  macOS promotion tool and the Windows tester-release accessibility gate.
- Release runbook: `docs/release/linux-release.md`.
- **Exit:** a dispatch produces a versioned, checksummed, documented Linux release attached to
  a GitHub release, gated by readiness + accessibility inputs.

### Phase R2 — Feature parity sweep (the gap)

Gaps where the Avalonia shell trails the WPF app (shared with macOS; see
[multiplatform-macos-port.md](multiplatform-macos-port.md) "Remaining blockers"). Priority for
a credible Linux release:

| Area | WPF today | Avalonia today | Priority |
| --- | --- | --- | --- |
| Open/edit/save, navigation, formulas, recalc | full | full (shared core) | done |
| Number/format/alignment/borders/styles | full | compact Format Cells (first-pass apply set) | P0 — broaden apply + dialog parity |
| Find/Replace/Go To/Go To Special | full dialogs | compact dialogs + shared session | P1 — parity polish |
| Data: sort/filter/dedup/subtotal/validation/what-if/forecast | full dialogs | compact routes + planners | P1 |
| Clipboard / Paste Special | full incl. multi-range | text + internal + image + most Paste Special; multi-range partial | P1 |
| Charts | full render + edit | preview bounds only | P2 — render parity is large |
| PivotTables | full | model + limited surface | P2 |
| Print / export | WPF print, PDFsharp, XPS, embedded-font Unicode PDF | portable PDF (ASCII+WinAnsi) | P1 PDF breadth; P2 print/XPS |
| Ribbon / backstage / task panes | mature | native menu + toolbar subset | P1 — cover command surface, not necessarily ribbon chrome |
| Drawing-object editing | full | preview render + select | P2 |
| Localization | many cultures | English-only UI strings | P1 — extract/share UI text |
| Color picker / remembered colors | full | default palette swatches | P2 |

Approach: keep logic in shared `FreeX.App.Services` (portable) wherever possible; add
Avalonia-specific UI only for rendering/interaction. Each chunk ships shared planner/service +
Avalonia wiring + tests + smoke evidence.

### Phase R3 — Quality, fidelity, accessibility on Linux

- Run the XLSX fidelity/recalc lanes that are portable on a Linux runner for parity evidence.
- Linux accessibility: AT-SPI automation evidence in the launch smoke; keyboard-only parity;
  Orca screen-reader pass; X11 + Wayland.
- `docs/release/linux-public-preview-checklist.md` human gates completed and validated by a
  promotion tool.

### Phase R4 — Distribution and trust

- Trust model: AppImage signature and/or detached signatures; checksum publication.
- Distro packaging: `.deb`/`.rpm`, and a Flatpak manifest (sandbox-friendly portals for files).
- Update mechanism (AppImageUpdate or distro/Flatpak channels).

## Sequencing

R1 (release channel) and R2-P0 (broaden Format Cells apply) are the immediate, high-value,
verifiable steps. R2-P1 items follow by command-surface coverage. R3 accessibility runs in
parallel as features land. R4 distribution is gated on a validated R1+R3 preview.

## Non-Goals (for first comparable release)

- Reproducing the exact WPF ribbon/backstage chrome pixel-for-pixel; a Linux-appropriate
  menu+toolbar that covers the command surface is acceptable.
- WPF-specific XPS export and native Windows print panels.
- Excel COM fidelity tooling (Windows-only).
