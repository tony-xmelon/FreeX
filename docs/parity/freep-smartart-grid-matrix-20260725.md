# FreeP SmartArt Grid Matrix

The native `gridMatrix` SmartArt layout is now admitted to the shared live
Matrix engine. It can be selected through the SmartArt Layouts ribbon in both
WPF and Avalonia, persists the standard diagram layout URI, and regenerates
larger node sets as a two-column multi-row grid rather than retaining only the
cached drawing.

The renderer-neutral implementation intentionally reuses the bounded Matrix
geometry. PowerPoint-specific titles, effects, relationship semantics, and
other Matrix layout families remain separate work.
