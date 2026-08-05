# FreeW Read Aloud Pause/Resume Parity

The WPF authority uses `System.Speech.Synthesis.SpeechSynthesizer.Pause` and
`Resume`. Avalonia now reports pause capability per selected backend and only
transitions the shared controller state after a successful operation.

On Linux and macOS, `espeak`/`espeak-ng` and macOS `say` are treated as owned
speech processes and receive platform-appropriate `SIGSTOP`/`SIGCONT` signals
for the exact child PID. `spd-say` remains unsupported because it delegates
audio to a separate speech-dispatcher daemon; suspending its client would not
pause the utterance. On Windows, the PowerShell/System.Speech backend suspends
and resumes its exact owned process through `NtSuspendProcess` and
`NtResumeProcess`; WPF is unchanged.

Focused coverage is in `freew/FreeW.App.Avalonia.Tests/ReadAloudParityTests.cs`.
The Windows integration contract proves observable child progress stops while
suspended, resumes afterward, and leaves no owned process or temporary file.
The Docker evidence lane is `tools/Run-FreeWReadAloudPauseValidation.ps1` and
retains the production app log plus `result.json` under
`artifacts/freew-read-aloud-pause-linux/`. It synthesizes to a temporary WAV,
so it does not require audible output.
