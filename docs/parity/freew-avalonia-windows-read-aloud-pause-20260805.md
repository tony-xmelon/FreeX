# FreeW Avalonia Windows Read Aloud pause parity

Date: 2026-08-05

## Scope

The WPF host pauses `SystemSpeechEngine` directly, while Avalonia's Windows backend ran
`System.Speech.Synthesis.SpeechSynthesizer` inside one owned PowerShell process and
reported pause as unsupported. The cross-platform controller therefore could not enter
its paused state on Windows.

## Result

- The Windows PowerShell speech backend now advertises pause support.
- `PlatformSpeechProcess` suspends and resumes only its exact owned Windows process via
  `NtSuspendProcess` and `NtResumeProcess`.
- Linux and macOS retain their existing exact-process signal behavior.
- A per-process pause-state guard prevents nested suspend counts and unmatched resumes.
- Stop/dispose continue to kill and reap only the process created by the speech runner.

## Verification

- Windows process integration contract: 1/1 passed. A real owned PowerShell child wrote
  an output file, stopped changing while suspended, resumed changing after resume, and
  was reaped and cleaned up.
- Complete Avalonia `ReadAloudParityTests`: 20/20 passed with `--no-build`.
- `FreeW.App.Avalonia` Release build: 0 warnings, 0 errors.

The integration probe uses a silent file-producing PowerShell child, so it validates the
same process ownership/control mechanism without playing audio or depending on an
installed voice.

## Process rule

Process-level media controls are valid only when the host owns the process that owns the
work. Prove pause with observable progress, prevent nested suspension, and always resume
or reap the exact PID in test cleanup; never use machine-wide process termination.
