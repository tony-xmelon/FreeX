# Ribbon Wave 84 Split-Button Parity

Wave 84 closes the shared renderer split-button interaction gap for Medium and Small controls. WPF and Avalonia now expose separate primary and dropdown targets, route their actions independently, preserve the menu flyout, and use the shared 20px Medium and 14px Small dropdown metrics.

The remaining difference is visual-only: WPF receives theme-owned button chrome from WPF resource styles, while Avalonia uses its equivalent custom flat templates and chevron path. Exact raster details such as antialiasing and native hover treatment remain platform-specific.
