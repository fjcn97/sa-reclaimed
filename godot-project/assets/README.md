# Godot asset boundary

The remake currently builds its debug-friendly entity, terrain, HUD, and screen
visuals procedurally at runtime. The original extracted source data remains
outside the Godot project under the configurable
`sa_reclaimed/source_data_root` setting (default: `res://../data`).

Use this directory for Godot-owned imported assets that are intentionally part
of the project, such as authored textures, audio, fonts, or packed visual
resources. Do not copy the extracted source-map binaries here; keep them in the
source-data tree so `SourceDataPaths.gd` and `SourceMapLoader.gd` remain the
single loading boundary.
