# Sonic Advance Reclaimed — Godot project

## Runtime structure

  - `scenes/Main.tscn` is the composition root for gameplay, HUD, touch controls,
    and state-driven presentation layers. Its packed `ScreenStack.tscn` composes
    three owned screen packs: `ScreenStackFrontend.tscn`,
    `ScreenStackOptions.tscn`, and `ScreenStackRuntime.tscn`.
    `scripts/Main.gd` exposes the stable composition/query API and
    `scripts/ui/ScreenRegistry.gd` recursively discovers nested screen layers
    without owning their state machines.
  - `Main.tscn` keeps only resources used by the composition root; screen script
    resources are owned by their domain-specific packed scene, avoiding duplicate
    scene wiring and allowing menu, options, and runtime screens to evolve
    independently.
- `scripts/CoreBridge.gd` owns the source-compatible gameplay/state contract and
  remains the autoload boundary.
- `scripts/core/` contains reusable runtime services that should not depend on
  individual screens. `InputBindings.gd` is the canonical GBA-style input
  bitfield mapping, while `PlayerState.gd`, `CameraState.gd`, `LevelState.gd`,
  and `PlatformState.gd` define the shared runtime snapshots and containers.
  `EntityState.gd` is the reusable per-entity runtime record used by level
  construction, interaction, and entity motion; `CoreBridge.gd` keeps the
  simulation orchestration and source-compatible access contract.
  `PlatformBuilder.gd` owns the reusable platform geometry constructors, while
  the bridge retains compatibility wrappers for existing level-generation
  callers.
  `SourceEntityCatalog.gd` owns source-kind-to-entity, item, gravity, and
  spring mappings; imported source data can therefore be interpreted without
  depending on the autoload instance.
- `SourceTileGraphics.gd` centralizes source tilemap word reads and 8x8 atlas
  extraction/flipping for the foreground, background, and standalone tilemap
  adapters.
  `SourceEnemyConfigurator.gd` initializes imported enemy records from source
  rows without depending on `CoreBridge`; the bridge keeps a compatibility
  wrapper for level loading.
- `SourceEntityLoader.gd` owns source entity placement and source-specific
  interactable setup; `SourceTerrainLoader.gd` owns terrain sampling and
  terrain-to-platform conversion. The bridge passes imported manifest and
  runtime context explicitly.
- `EntityFactory.gd` owns default runtime dimensions, animation IDs, and
  behavior flags for newly created entities; simulation code only supplies the
  level, type, and position.
- `EntitySpawner.gd` owns higher-level ring, enemy, boss, interactable, and
  effect spawn helpers; `CoreBridge.gd` retains compatibility wrappers.
- `LevelBuilder.gd` composes the built-in stage layout from the platform and
  entity services; source-map application remains a separate loader phase.
- `PlatformMotionSystem.gd` advances moving, arrow, speeding, and crumbling
  platforms while receiving player geometry and gravity context explicitly.
- `PlatformCollisionSystem.gd` resolves normal/inverted platform landing,
  slope rotation, and platform activation while returning vertical velocity to
  the bridge.
- `EntityInteractionDispatcher.gd` owns entity-type routing and calls the
  bridge’s existing interaction handlers through an explicit compatibility
  boundary.
- `EnemyMotionDispatcher.gd` owns enemy/effect motion routing and simple
  projectile, fan, and patrol updates while species-specific handlers remain
  behind the bridge boundary.
  `SaveFileStore.gd` isolates JSON file and backup I/O from the gameplay state
  migration logic in `CoreBridge.gd`. `RuntimeSettings.gd` centralizes typed
  access to project-level runtime flags.
- `EntityVisualCatalog.gd` owns the reusable visual profile data consumed by
  entity rendering, while `EntityTypes.gd` owns the stable entity ID contract;
  `CoreBridge.gd` retains the source-compatible aliases.
- `StageBackdropCatalog.gd` owns the static backdrop palette and hill geometry
  selected by level ID, keeping presentation data out of the state bridge.
- `SoundTestCatalog.gd` owns immutable track metadata, unlock order, and tempo
  data; `CoreBridge` retains only the menu cursor and unlock state.
- `CharacterCatalog.gd` owns immutable character metadata and the default Tiny
  Chao roster; unlock flags, route completion, and profile state remain in the
  bridge.
- `SpecialStageCatalog.gd` owns immutable robot-speed and ring-route
  checkpoints; special-stage timers and progression remain in `CoreBridge`.
- `CreditsCatalog.gd` owns immutable slide groups, source tile IDs, and ending
  delays; page and ending-variant state remains in the bridge.
- `LevelCatalog.gd` owns immutable level names; selection, unlock, and clear
  progress remain mutable bridge state.
- `ProfileCatalog.gd` owns allowed profile-name characters and default button
  bindings; edited profile data remains save-backed bridge state.
- `LocalizationCatalog.gd` owns language names and translated menu tokens;
  `CoreBridge` retains the language-selection state and compatibility wrapper.
- `FlowStates.gd` owns stable game-state, title-phase, options, and menu
  context identifiers; `CoreBridge` exposes compatibility aliases for legacy
  callers.
- `SourceDataPaths.gd` is the single source-data path contract. The default
  root is `res://../data`, configurable through
  `sa_reclaimed/source_data_root`; this keeps extracted maps and graphics
  outside the Godot project while making their location explicit.
  - `scripts/ui/ScreenBase.gd` contains shared CanvasLayer construction helpers.
  - `scripts/ui/UiNodeFactory.gd` owns shared `ColorRect` and `Label`
    construction. `ScreenBase.gd` exposes the screen-facing helper API and HUD
    delegates to the same factory, keeping presentation-specific layout in each
    screen while centralizing node creation.
  - `scripts/ui/EntityVisualRenderer.gd` owns reusable StageEntity drawing and
    state binding; `scripts/StageEntity.gd` remains a compatibility alias for
    existing scene and source callers.
  - `scripts/ui/EntitySpriteTextureFactory.gd` owns procedural textures and
    item icons used by `EntitySprite.gd`, leaving the scene-facing script
    responsible for binding, fallback routing, and animation.
  - `scripts/ui/HudStatePresenter.gd` owns localized HUD state queries; the
    `CoreBridge` methods remain compatibility wrappers for existing HUD and
    gameplay callers.
  - `scripts/ui/HudChromeBuilder.gd` owns HUD chrome/panel construction and
    returns named nodes to `HUD.gd`; per-frame state updates remain in the HUD
    presenter script.
  - `scripts/ui/CourseMapView.gd` owns course-select map nodes, links, emerald
    marker positioning, travel interpolation, and map animation; the screen
    script retains course rows, banners, and flow-state presentation.
  - `scripts/ui/CharacterWheelView.gd` owns character-wheel geometry, roster
    nodes, bobbing, and selected-ring interpolation; `CharacterSelectScreen.gd`
    retains roster rows, details, chrome, and selection flow.
  - `scripts/core/SpecialStageSystem.gd` owns special-stage entry, lane-run,
    guard-robot, results, and completion phases; `CoreBridge` retains the
    original method names as state-machine adapters.
  - `scripts/core/InputDeviceSampler.gd` owns keyboard, joypad-button, and
    analog-axis translation; `PlayerController.gd` retains input state,
    repeat timing, touch, and menu/gameplay dispatch.
  - `scripts/core/MenuInputRepeater.gd` owns the source-accurate first-repeat
    and continued-repeat timers used by menus and name entry.
  - `scripts/core/MenuInputRouter.gd` owns source-order-sensitive menu routing;
    `PlayerController.gd` retains the compatibility entry point and raw input
    state while delegating menu decisions to the router.
  - `scripts/core/SourceMetatileCache.gd` owns source atlas loading and
    metatile texture construction; `SourceTerrainRenderer.gd` only maps cached
    textures into runtime stage coordinates.
  - `scripts/core/StageMechanismStateSystem.gd` owns pure timer/phase updates
    for spike platforms, keyboards, light globes, and wind-up sticks; the bridge
    keeps source-compatible adapters for existing callers.
  - `scripts/core/StageTraversalSystem.gd` owns turnaround-bar and pole player
    traversal state, plus crane, slope, loop, funnel, music-entry, half-pipe,
    flying-handle, and German-flute updates; it returns the bridge-owned
    vertical velocity after each update.
  - `scripts/core/StageInteractionSystem.gd` owns player-facing small-windmill
    and chord interaction state updates.
  - `scripts/core/TinyChaoGardenSystem.gd` owns Tiny Chao garden selection,
    movement, care, and action state; `CoreBridge.gd` retains persistence and
    screen-transition responsibilities.
  - `scripts/core/SaveProfileCodec.gd` owns the stable profile-to-JSON field
    mapping; `SaveFileStore.gd` owns file writes and backup recovery.
  - `scripts/core/SaveProfileSanitizer.gd` owns load-time validation for names,
    bindings, records, time-attack tables, and Tiny Chao roster data.
  - `scripts/core/MultiplayerRecordSystem.gd` owns persistent multiplayer
    record insertion, promotion, and result accounting.
  - `scripts/core/TimeAttackRecordSystem.gd` owns time-attack record keys,
    best-time lookup, and top-three result insertion.
  - `scripts/core/ChaosEmeraldProgressionSystem.gd` owns per-character emerald
    masks, emerald counting, and flattened-course zone indexing.
  - `scripts/core/StoryUnlockSystem.gd` owns route-based unlock rules for Tiny
    Chao, sound test, boss time attack, characters, and True Area progression.
  - `scripts/core/ClearResultCounterSystem.gd` owns clear-results bonus
    draining and source-accurate normal/fast-forward post-count tails.
  - `scripts/core/EnemyMotionSystem.gd` owns Pen, Mouse, Circus, Yado, Straw,
    Gejigeji, Kubinaga, Madillo, Kyura, Flickey, Mon, Buzzer, Balloon, Bullet
    Buzzer, Balloon, Bullet Buzzer, scattered-ring, Koura, Pikopiko, Kiki, Kiki projectile/fragment, and trapped-animal motion; projectile creation remains an explicit bridge callback while
    `EnemyMotionDispatcher.gd` retains entity-type routing.
  - `scripts/core/BossMotionSystem.gd` owns the generic and profile-specific
    boss motion state machines, projectile volleys, beam geometry, and boss
    projectile setup; `CoreBridge.gd` retains compatibility adapters.
  - `scripts/core/CameraMotionSystem.gd` owns camera clamping, Super Sonic
    look-ahead, and screen-shake state; `CoreBridge.gd` retains the existing
    camera and shake method surface.
  - `scripts/core/InputBufferSystem.gd` owns recent-frame input history and
    jump buffering; the bridge retains compatibility methods for callers that
    consume the buffered mask.
  - `LocalizationCatalog.gd` owns localized status-message formatting,
    including dynamic reset, player-layer, and unlock messages; the bridge
    retains the existing status query surface.
  - `scripts/ui/HudStatePresenter.gd` owns multiplayer HUD ranking and row
    formatting alongside the existing HUD text and chrome queries.
  - `scripts/ui/PlayerVisualPresenter.gd` owns player-visibility rules and
    character palette selection; `CoreBridge.gd` retains visual query adapters.
  - `scripts/ui/TouchControlsPresenter.gd` owns touch-device policy,
    touch-layer visibility, and platform-specific navigation labels; the
    bridge retains compatibility queries for `TouchControls.gd`.
  - `scripts/ui/TimeAttackLobbyPresenter.gd` owns time-attack lobby text,
    record labels, course badges, accents, and chrome colors; lobby state and
    transitions remain bridge-owned.
  - `scripts/ui/OptionsPresenter.gd` owns options/player-data presentation,
    difficulty, time-limit, language, button-config, and delete-confirmation
    text/chrome; option navigation, bindings, and mutations remain bridge-owned.
  - `scripts/ui/TimeAttackResultsPresenter.gd` owns the time-attack results
    card's progress and localized result fields; result progression remains
    bridge-owned.
  - `scripts/ui/GameOverPresenter.gd` owns Game Over copy and animation-derived
    presentation values; automatic retry/title flow remains bridge-owned.
  - `scripts/ui/SpecialStagePresenter.gd` owns special-stage pause, intro,
    run, and results formatting; special-stage simulation remains bridge-owned.
  - `scripts/ui/EndingPresentationPresenter.gd` owns story interstitial,
    logo, and credits-page formatting; ending progression and skip rules
    remain bridge-owned.
  - `scripts/ui/ClearResultsPresenter.gd` owns normal/time-attack clear-card
    formatting, rows, medals, rank copy, and chrome; score counting and clear
    progression remain bridge-owned.
  - `scripts/ui/CourseSelectPresenter.gd` owns course-map nodes, selection
    rows, labels, banners, emerald badges, and localized course-select copy;
    travel, unlock, and selection state remain bridge-owned.
  - `scripts/ui/MultiplayerResultsPresenter.gd` owns post-match result copy,
    option rows, and chrome; multiplayer result resolution and record commits
    remain bridge-owned.
  - `scripts/ui/MultiplayerLobbyPresenter.gd` owns room prompts, vote
    summaries, option rows, linked-player statuses, and chrome; room lifecycle
    and synchronization remain bridge-owned.
  - `scripts/ui/CharacterSelectPresenter.gd` owns character descriptions,
    carousel rows, context labels, prompts, status copy, and chrome; selection
    rules and unlock state remain bridge-owned.
  - `scripts/ui/TinyChaoPresenter.gd` owns Tiny Chao menu/play rows, status,
    handoff summaries, info fields, and localized copy; garden simulation and
    session mutation remain bridge-owned.
  - `scripts/ui/PlayModePresenter.gd` owns Play Mode rows, summaries, prompts,
    and chrome; play-mode navigation and profile gating remain bridge-owned.
  - `scripts/ui/SinglePlayerMenuPresenter.gd` owns single-player menu rows,
    summaries, prompts, and chrome; menu navigation and unlock gating remain
    bridge-owned.
  - `scripts/ui/MultiplayerModePresenter.gd` owns link-mode rows, summaries,
    prompts, info, badges, and chrome; link selection and profile gating remain
    bridge-owned.
  - `scripts/ui/TimeAttackModePresenter.gd` owns time-attack mode rows,
    summaries, prompts, info, and detail copy; attack-mode selection and unlock
    state remain bridge-owned.
  - `scripts/ui/PausePresenter.gd` owns pause copy, menu rows, summaries,
    badges, and chrome; pause input and return routing remain bridge-owned.
  - `scripts/ui/MultiplayerCommPresenter.gd` owns communication/sync titles,
    prompts, details, summaries, status labels, and chrome; synchronization
    state mutation and link routing remain bridge-owned.
  - `scripts/ui/NameEntryPresenter.gd` owns profile-name entry copy, control
    labels, summaries, guides, and chrome; character-board navigation and save
    mutation remain bridge-owned.
  - `scripts/core/EffectMotionSystem.gd` owns ring, heart, dust,
    character-attack, and item-box animation/lifetime updates; gameplay
    application and grind effects remain bridge-owned.
  - `scripts/core/CompanionMotionSystem.gd` owns Cheese follow/bob motion;
    `CoreBridge.gd` retains companion references and lifecycle cleanup.
  - `scripts/core/StageSurfaceStateSystem.gd` owns slowing-snow and slidy-ice
    contact queries plus light-bridge phase/layer updates; bridge flags remain
    compatibility-facing state.
  - `scripts/core/StageMotionSystem.gd` owns flying and floating spring motion;
    the bridge exposes the original update method as a compatibility adapter.
  - `scripts/ui/IntroSourceArtView.gd` owns final-intro source tilemap texture
    composition and caching; `IntroScreen.gd` retains timing and chrome state.
  - `scripts/audio/SoundTestPreviewGenerator.gd` owns procedural preview stream
    generation; `SoundTestScreen.gd` retains playback lifecycle and presentation.
  - `scripts/ui/TimeRecordsTableView.gd` owns time-record row construction,
    layout variants, and selection styling; `TimeRecordsScreen.gd` retains the
    surrounding chrome and navigation presentation.
- `tests/smoke/` contains focused executable checks for source flows,
  persistence, input, and entity behavior.
- `tests/analysis/` contains source-coverage and data-inspection probes, while
  `tests/tools/` contains small project diagnostics.

## Validation

Run from the repository root:

```powershell
$project = "godot-project"
godot.exe --headless --path $project --editor --quit
godot.exe --headless --path $project --log-file "$PWD/godot-test.log" --script res://tests/smoke/input_mapping_smoke.gd
godot.exe --headless --path $project --log-file "$PWD/godot-test.log" --script res://tests/smoke/title_flow_smoke.gd
```

To run every smoke test from the repository root:

```powershell
& .\godot-project\tests\run_smoke_suite.ps1
```

For restricted Windows environments, run the deterministic batches separately:

```powershell
& .\godot-project\tests\run_smoke_suite.ps1 -TestPattern '^[a-m]'
& .\godot-project\tests\run_smoke_suite.ps1 -TestPattern '^[n-z]'
```

The suite performs an editor preflight before launching individual tests so
Godot refreshes its script-class cache after source changes.

Each test is launched in an isolated process with an explicit `--log-file`,
keeping headless runs independent of a machine's `user://` log directory and
preventing orphaned Godot processes from blocking later tests.
