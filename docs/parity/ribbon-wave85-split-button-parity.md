# Ribbon Wave 85 Split-Button Parity

Wave 85 closes two shared-renderer contract gaps around Large and adaptive split buttons. Avalonia now assigns the same derived, collision-safe keytip to collapsed group overflow buttons as WPF, so an adaptive group can be entered and its menu action invoked by keytip. Split dropdowns also remain enabled when the primary command is unavailable but the dropdown menu has entries, matching WPF across Large, Medium, and Small layouts.

Both renderers retain independent primary and dropdown targets, fixed layout metrics, disabled menu-item filtering, and platform-native popup/focus behavior. WPF ContextMenu and Avalonia MenuFlyout lifecycle details remain platform-specific; tests cover the shared routing and enabled-state contract rather than pixel-identical popup chrome.
