# FreeW Read Aloud Pause/Resume Parity

The WPF authority uses `System.Speech.Synthesis.SpeechSynthesizer.Pause` and
`Resume`. Avalonia now reports pause capability per selected backend and only
transitions the shared controller state after a successful operation.

On Linux and macOS, `espeak`/`espeak-ng` and macOS `say` are treated as owned
speech processes and receive platform-appropriate `SIGSTOP`/`SIGCONT` signals
for the exact child PID. `spd-say` remains unsupported because it delegates
audio to a separate speech-dispatcher daemon; suspending its client would not
pause the utterance. Windows command-line fallback remains unsupported in the
Avalonia adapter; WPF is unchanged.

Focused coverage is in `freew/FreeW.App.Avalonia.Tests/ReadAloudParityTests.cs`.
The Docker evidence lane is `tools/Run-FreeWReadAloudPauseValidation.ps1` and
retains the production app log plus `result.json` under
`artifacts/freew-read-aloud-pause-linux/`. It synthesizes to a temporary WAV,
so it does not require audible output.
