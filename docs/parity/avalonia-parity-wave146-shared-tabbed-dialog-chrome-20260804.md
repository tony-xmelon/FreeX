# Avalonia/WPF Parity Wave 146: Shared Tabbed-Dialog Chrome

Wave 146 makes the selected-tab/content seam an explicit shared contract for the WPF and Avalonia
dialog hosts. Both hosts now use the same one-pixel body frame and one-pixel selected-header overlap,
so the selected tab meets its content with zero gap and without a second separating border.

The contract lives in `Free.Shared.Shell.DialogTabChromeMetrics`; paired WPF and Avalonia tests assert
the border, margin, and content-host values. The shared Legal Notices dialog is the only production
consumer wired directly in this slice; no app-local dialog files were changed.
