# FreeP Wave185 bullets/autofit evidence

Date: 2026-08-23  
Source revision: `dc489d2ef0`  
Corpus: `17-bullets-autofit.pptx`, 1280x720

Wave185 targets slide 02, the current Office residual. The cause is a bounded
Avalonia host fallback calibration: fixed-size, single-column, no-autofit,
non-bullet 18pt Aptos body text uses Arial with a `0.930` measurement/paint
scale. Bullet, autofit, non-Aptos, non-18pt, and multi-column routes remain
outside the policy. WPF and shared text/autofit semantics are unchanged.

| Comparison | Wave184 | Wave185 | Delta |
| --- | ---: | ---: | ---: |
| WPF vs Office, slide 02 | 3.0587% | 3.0587% | 0.0000 pp |
| Avalonia vs Office, slide 02 | 3.0055% | **2.5360%** | -0.4695 pp |
| WPF vs Avalonia, slide 02 | 3.0952% | **2.9091%** | -0.1861 pp |

The slide 01 control remains `0.8441%` WPF vs Office, `0.8339%` Avalonia vs
Office, and `0.8439%` pair. Its Avalonia PNG is SHA-256 byte-identical to the
Wave185 baseline; WPF slide 02 is also byte-identical. The changed Avalonia
slide 02 was rerendered at `artifacts/wave185-final/avalonia/slide-02.png`.

The authoritative recalibration starts from the exact Wave184 aggregates and
applies only the slide-02 Avalonia and pair deltas, producing corpus averages
of `1.0593%` WPF, `1.0271%` Avalonia, and `0.6248%` pair; maxima are
`3.0587%`, `2.9238%`, and `1.6684%` respectively. PowerPoint COM was not
required; the committed Office PNG remains the authority.

Focused verification: host policy `2/2`, `BulletsAutofitTests` `56/56`, and
the RenderCompare Release build passed with zero warnings/errors.
