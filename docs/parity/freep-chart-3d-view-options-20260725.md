# FreeP chart 3-D view authoring

FreeP now exposes the chart camera and Surface3D wireframe settings that were already
preserved by the PPTX reader, writer, and render planners. The shared command covers elevation,
rotation, perspective, height, depth, right-angle axes, and explicit wireframe state, with one
undo step and matching WPF/Avalonia dialogs.

Blank numeric or boolean values preserve the chart's automatic/default behavior. The wireframe
control is serialized only when explicitly set, including an explicit `off` value.
