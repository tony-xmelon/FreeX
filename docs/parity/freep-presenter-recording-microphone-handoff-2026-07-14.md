# FreeP Presenter Recording Microphone Handoff - 2026-07-14

This slice advances FreeP presenter recording parity by turning the now-concrete WPF and Avalonia Windows microphone adapters into shared, no-COM parity evidence.

Parity improved:

- `SlideShowRecordingHostAdapterParityPlanner` projects host adapter readiness rows from the shared `SlideShowRecordingCaptureAdapterReadiness` contract.
- The shared planner now proves WPF and Avalonia both expose real Windows microphone narration handoff through host recording adapters.
- Camera capture remains explicitly deferred in the same evidence instead of being flattened into the microphone claim.
- Existing WPF and Avalonia adapter tests continue to prove the concrete host adapters can start narration capture, complete package-ready WAV artifacts, and leave camera video deferred without touching PowerPoint COM.

Verification:

- `freep/FreeP.App.Presentation.Tests/SlideShowRecordingHostAdapterParityPlannerTests.cs`
- `freep/FreeP.App.Host.Tests/WpfWindowsRecordingCaptureBackendTests.cs`
- `freep/FreeP.App.Avalonia.Tests/AvaloniaWindowsRecordingCaptureBackendTests.cs`

Remaining gaps:

- Real camera capture is still deferred.
- PowerPoint COM-backed recording capture baselines still require a COM-capable machine.
- Broader real-deck PowerPoint-native media/caption corpus baselines remain deferred.
