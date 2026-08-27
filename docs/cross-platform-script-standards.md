# Cross-platform script standards

Repository preflight enforces these rules for every tracked workflow and script.

- Use `tools/ToolScriptSupport.ps1` for host detection, full/canonical paths, path comparison, repository-relative paths, temporary directories, and child processes.
- Treat physical paths as case-insensitive only on Windows. Linux and macOS comparisons are ordinal and case-sensitive.
- Resolve existing Unix paths before comparing them so aliases and nested symlinks such as `/var` to `/private/var` cannot disagree with child-process output.
- Store repository and MSBuild paths with `/`. Convert user input through `ConvertTo-ToolPlatformPath` or `Resolve-ToolRepoPath` at the filesystem boundary.
- Use `[IO.Path]::PathSeparator` for `PATH`, and both directory separator characters when trimming external input.
- Use `Test-ToolIsWindows`, `Test-ToolIsLinux`, and `Test-ToolIsMacOS`; do not use PowerShell 6+ automatic platform variables in scripts that are also parsed or run by Windows PowerShell 5.1.
- Invoke `pwsh`, not `pwsh.exe`, in portable code. Windows-only scripts and commands must stay in the explicit Windows-only inventory.
- Shared Linux/macOS shell scripts must avoid GNU-only flags and commands. Linux packaging and Docker/X11 probes are explicitly Linux-scoped and are still syntax-checked.
- Keep PowerShell, shell, Python, Node, workflow, project, solution, generated-document, and packaging text files as UTF-8 without a BOM, with LF endings and a final newline.
- Hash generated text after newline normalization. Hash packaged binaries as bytes.
- Keep repository symlinks relative, within the repository, and pointed at tracked targets. Avoid symlinks in release archives unless the package contract explicitly requires them.
- Use invariant formatting for generated machine-readable values and construct literal suffixes such as `%` separately from culture-sensitive numeric formatting.

`tools/Test-CrossPlatformPortability.ps1` validates path collisions and reserved names, Unicode normalization, line endings, syntax, static path casing, shell portability, PowerShell host compatibility, MSBuild references, symlinks, and release-workflow command scope. It runs from `tools/Test-RepositoryPreflight.ps1` on Windows, Linux, and macOS.
