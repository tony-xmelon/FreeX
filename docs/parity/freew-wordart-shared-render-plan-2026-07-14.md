# FreeW WordArt Shared Render Plan - 2026-07-14

This slice moves WordArt preset render facts into `FreeW.App.Presentation` so WPF and Avalonia consume one shared style/effect plan. The shared plan records fill kind, gradient stops, pattern metadata, outline color, bold state, shadow/glow/reflection/bevel flags, and warp hint metadata before either renderer creates platform brushes or effects.

The focused tests prove the shared plan is consumed by inline and floating WordArt paths in both renderers. Authoritative Microsoft Word PNG baselines still need to run later on a Word-installed machine; this host cannot provide that final baseline because `Word.Application` COM is not registered here.
