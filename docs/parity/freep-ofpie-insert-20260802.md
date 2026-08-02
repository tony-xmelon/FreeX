# FreeP OfPie Chart Insertion

FreeP already supported `ChartType.OfPie` in the model, DOCX read/write path, chart options, and renderers, but the Insert Chart catalog did not expose it. The shared insertion planner and WPF/Avalonia ribbon profiles now expose **Pie of Pie / Bar of Pie** and route it through the normal undoable chart insertion command.

Coverage includes planner mapping, localized label/key tip, host icon registration, ribbon presence, and WPF/Avalonia insertion contracts.
