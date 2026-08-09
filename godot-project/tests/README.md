# Godot validation tools

The test scripts are kept outside the runtime source tree so the project root
and `scripts/` directory contain only application code and configuration.

- `smoke/` contains executable Godot smoke tests.
- `analysis/` contains source/data inspection scripts.
- `tools/` contains project diagnostics.
- `run_smoke_suite.ps1` runs every script in `smoke/` with an explicit writable
  log location, parses the plain-text Godot logs, reports each check count, and
  fails if a normal smoke test does not emit its check summary. The
  `boss_route_smoke.gd` diagnostic is the only intentional summary exception.

Smoke scripts load the project by path, so they can continue to exercise the
same autoloads, scenes, and runtime classes as the game itself.
