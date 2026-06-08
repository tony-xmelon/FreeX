# macOS Hosted Runner Build Plan

**Last updated:** 2026-06-08

This note answers how GitHub-hosted macOS runners can produce a downloadable FreeX `.app` artifact, what is already wired in the repository, and what still has to pass before a macOS build is trusted enough for testers outside the internal preview loop.

## Hosted Build Shape

The build path is the `macOS App Preview` workflow at `.github/workflows/macos-app.yml`. It does not require a developer-owned Mac because the app bundle is assembled, signed, smoke-tested, zipped, and uploaded on GitHub-hosted macOS runners:

1. Run the matrix for both supported runtimes:
   - `osx-arm64` on `macos-latest`
   - `osx-x64` on `macos-15-intel`
2. Checkout the repository and install `.NET 10` with `actions/setup-dotnet`.
3. Capture runner/toolchain evidence, including `RUNNER_OS`, `RUNNER_ARCH`, `ImageOS`, `ImageVersion`, `sw_vers`, `uname -m`, `dotnet --info`, and `xcodebuild -version`.
4. Run focused portable macOS test slices for PDF export planning, export path guards, source/readiness guards, and launch-smoke report key drift before packaging.
5. Build `src/FreeX.App.Avalonia/FreeX.App.Avalonia.csproj` in Release.
6. Publish the Avalonia app self-contained for the matrix runtime into `FreeX.app/Contents/MacOS` with `dotnet publish --runtime <runtime> --self-contained true`.
7. Copy the tracked macOS bundle files into place:
   - `src/FreeX.App.Avalonia/Packaging/macos/Info.plist`
   - `src/FreeX.App.Avalonia/Packaging/macos/FreeX.icns`
8. Validate bundle metadata with `plutil` and `PlistBuddy`, validate the native binary architecture with `lipo`, and verify executable bits.
9. Sign the bundle:
   - internal preview: ad-hoc signing by default;
   - distribution candidate: Developer ID signing from GitHub Secrets, accepted notarization with `xcrun notarytool`, stapling, and stapler validation.
10. Zip the bundle with `ditto --keepParent`, generate and verify `freex-<runtime>-macos-app.zip.sha256`, unzip the zip back out, recheck bundle contents, and run `codesign --verify`.
11. Record Gatekeeper assessment with `spctl`, then run native-architecture packaging and LaunchServices/Open-With/default-open smoke where the hosted runner can execute the runtime.
12. Upload the app artifact and always-on diagnostics artifact with workflow artifacts.

GitHub's hosted-runner documentation treats `-latest` labels as GitHub's latest stable runner image rather than necessarily the newest vendor OS, so the workflow's captured image/toolchain evidence should remain part of every artifact review.

## Already Wired

- `src/FreeX.App.Avalonia` targets `net10.0`, declares `RuntimeIdentifiers` for `osx-arm64` and `osx-x64`, and includes `Packaging/macos/FreeX.icns` as publish content.
- `Packaging/macos/Info.plist` declares `FreeX` as the executable, `io.github.tony-xmelon.freex` as the bundle id, `FreeX.icns` as the icon, `.fxl` as the owned workbook type, and common spreadsheet formats as alternate/viewer document types.
- `.github/workflows/ci.yml` has a portable hosted macOS lane that builds and tests `FreeX.DefaultTests.slnx` without pulling WPF, UI tests, or Windows-only tools into the macOS job.
- `.github/workflows/macos-app.yml` builds both runtime-specific `.app` bundles, uploads `freex-<run-id>-<run-attempt>-<runtime>-macos-app`, and preserves diagnostics with a separate always-on artifact.
- The uploaded app artifact includes the inner app zip, checksum, evidence file, packaging-smoke log, LaunchServices launch-smoke report, Open-With launch-smoke report, default-open launch-smoke report, notarization log, and tester instructions.
- The workflow separates `artifact_channel=internal-preview` from `artifact_channel=distribution-candidate`. Pull request runs never use Developer ID signing secrets; `workflow_dispatch` with `distribution_candidate=true` requires signing and notarization evidence.
- The distribution-candidate publication job downloads both runtime artifacts, revalidates evidence markers, prepares stable `FreeX-latest-macos-arm64.zip` and `FreeX-latest-macos-x64.zip` assets, writes a manifest, and creates or updates a prerelease GitHub Release.
- `tools/Test-MacOsAppReadiness.ps1` is wired into repository preflight for static macOS app readiness checks, and `tools/Test-MacOsPublicPreviewReadiness.ps1` validates downloaded evidence bundles on Windows after hosted packaging.
- Existing runbooks already cover retrieval, signing/notarization secrets, public-preview evidence validation, and human macOS checklist work:
  - `docs/release/macos-signing-notarization.md`
  - `docs/release/macos-public-preview-checklist.md`
  - `docs/planning/macos-accessibility-evidence.md`
  - `docs/planning/multiplatform-macos-port.md`

## Remaining Before A Trusted Tester Build

A hosted `.app` artifact is not automatically a trusted tester build. Treat default hosted outputs as internal previews until all of these are true:

1. Configure Developer ID and notarization secrets in GitHub:
   - `MACOS_CODESIGN_CERTIFICATE_P12`
   - `MACOS_CODESIGN_CERTIFICATE_PASSWORD`
   - `MACOS_DEVELOPER_ID_APPLICATION`
   - `MACOS_NOTARY_APPLE_ID`
   - `MACOS_NOTARY_TEAM_ID`
   - `MACOS_NOTARY_PASSWORD`
2. Dispatch `macOS App Preview` from `main` with `distribution_candidate=true`, and require both `osx-arm64` and `osx-x64` matrix jobs to pass.
3. Require evidence markers for both runtimes:
   - `artifact_channel=distribution-candidate`
   - `distribution_readiness=distribution_candidate_ready`
   - `codesign_verified=true`
   - `codesign_mode=developer-id`
   - `notarization_status=accepted`
   - `stapler_validated=true`
   - `gatekeeper_assessment_status=accepted`
   - `gatekeeper_assessment_source=Notarized Developer ID`
4. Download app and diagnostics artifacts, then run the Windows-runnable evidence preflight with distribution-candidate requirements:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Test-MacOsPublicPreviewReadiness.ps1 -ArtifactRoot artifacts/macos-preview -DistributionCandidate -RequireSeparateDiagnosticsArtifact
```

5. Preserve the checksum, evidence, smoke logs, notarization log, tester instructions, diagnostics artifact, run id, run attempt, source commit, and generated release manifest with the release record.
6. Complete human validation on real macOS hardware before calling the build tester-ready:
   - checksum verification from the downloaded files;
   - Finder double-click first launch with quarantine preserved;
   - Gatekeeper prompt/result capture;
   - `.fxl` Finder/Open With/default-handler behavior;
   - representative workbook create/open/edit/save/reopen smoke;
   - native Command-key menu behavior;
   - keyboard-only accessibility pass;
   - VoiceOver smoke pass;
   - known issues reviewed with severity, workaround, owner, and blocking decision.
7. Keep scope caveats explicit in tester notes. Hosted evidence already covers packaging, signing, notarization, LaunchServices, default-open, menu/dialog smoke, and selected workbook flows, but WPF/XPS export, native print rendering, embedded-font Unicode PDF rendering, full dialog/access-key parity, broader route parity evidence, and public-preview accessibility proof remain follow-up gates unless a release owner explicitly narrows the tester scope.

## References

- GitHub-hosted runners reference: https://docs.github.com/en/actions/reference/runners/github-hosted-runners
- GitHub workflow artifacts: https://docs.github.com/en/actions/concepts/workflows-and-actions/workflow-artifacts
