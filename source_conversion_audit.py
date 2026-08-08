"""Audit the SA2 source tree against the consolidated Godot remake.

The remake is intentionally many-to-one: CoreBridge owns the shared runtime
that is split across hundreds of original C files. This audit therefore checks
source categories and the explicitly non-matching SA2 assembly routines rather
than requiring a misleading same-basename file for every C module.
"""

from pathlib import Path


ROOT = Path(__file__).resolve().parent
SA2 = ROOT / "src" / "game" / "sa2"
NONMATCHING = ROOT / "asm" / "non_matching" / "game" / "sa2"
SOURCE_ROOTS = [ROOT / "src", ROOT / "libagbsyscall", ROOT / "multi_boot", ROOT / "chao_garden"]
ASM_ROOT = ROOT / "asm"

CATEGORY_TARGETS = {
    "stage": "godot-project/scripts/CoreBridge.gd + StageEntity.gd + source runtime smokes",
    "special_stage": "godot-project/scripts/SpecialStageScreen.gd + CoreBridge.gd + special-stage smokes",
    "ui": "godot-project/scripts/CoreBridge.gd + dedicated CanvasLayer screens",
    "menus": "godot-project/scripts/CoreBridge.gd + dedicated menu screens",
    "cutscenes": "godot-project/scripts/CoreBridge.gd + credits/intro screens",
    "multiplayer": "godot-project/scripts/CoreBridge.gd + multiplayer screens",
    "collect_rings": "godot-project/scripts/CoreBridge.gd + multiplayer/special-stage flows",
    "assets": "godot-project/scripts/SourceMapLoader.gd + SourceTilemapTexture.gd",
    "sound_test.c": "godot-project/scripts/SoundTestScreen.gd + CoreBridge.gd",
    "save.c": "godot-project/scripts/CoreBridge.gd + SaveScreen.gd",
	"title_screen.c": "godot-project/scripts/TitleScreen.gd + CoreBridge.gd",
	"bg_palette_effects.c": "godot-project/scripts/StageBackdrop.gd + SourceBackgroundProfile.gd",
	"options_screen.c": "godot-project/scripts/OptionsMainScreen.gd + CoreBridge.gd",
}

ALL_TREE_TARGETS = {
	"src": "Godot product integration or source build support; no standalone gameplay module",
    "src/game/sa1": "repository source for Sonic Advance 1; outside this SA2 remake product",
    "src/game/sa2": "CoreBridge.gd + dedicated Godot product screens and source-runtime tests",
    "src/game/shared": "CoreBridge.gd + shared stage/UI behavior and runtime smokes",
    "src/game": "shared game support consolidated into CoreBridge.gd",
    "src/platform": "Godot runtime/platform layer; no GBA backend is required",
    "src/lib": "Godot engine services or imported data; no one-to-one gameplay port",
    "src/data": "SourceMapLoader.gd + SourceTilemapTexture.gd",
    "libagbsyscall": "build-time GBA utility library; not product runtime",
    "multi_boot": "CoreBridge.gd single-pak/link flow; transport implementation is simulated",
    "chao_garden": "TinyChaoGardenScreen.gd + CoreBridge.gd",
}

NONMATCHING_TARGETS = {
    "super_sonic__sub_802BCCC.inc": "CoreBridge.gd + super_sonic_smoke.gd",
    "Task_Rotating.inc": "CoreBridge.gd + EntitySprite.gd + rotating_handle_smoke.gd",
    "Task_GrindRail_CollectRings.inc": "CoreBridge.gd + booster_grind_smoke.gd",
    "cannon__IsPlayerTouching.inc": "CoreBridge.gd + cannon_smoke.gd",
    "boss_4__sub_8041D34.inc": "CoreBridge.gd + boss_behavior_smoke.gd",
    "boss_5__sub_8045564.inc": "CoreBridge.gd + boss_behavior_smoke.gd",
    "boss_7__sub_8048C7C.inc": "CoreBridge.gd + boss_behavior_smoke.gd",
    "StageBgUpdate_Zone2Acts12.inc": "StageBackdrop.gd + SourceBackgroundProfile.gd",
    "StageBgUpdate_Zone3Acts12.inc": "StageBackdrop.gd + SourceBackgroundProfile.gd",
    "StageBgUpdate_Zone6Acts12.inc": "StageBackdrop.gd + SourceBackgroundProfile.gd",
    "Zone7BgUpdate_Inside.inc": "StageBackdrop.gd + SourceBackgroundProfile.gd",
    "sub_801D24C.inc": "StageBackdrop.gd + SourceBackgroundProfile.gd",
}

SHARED_ASSEMBLY_TARGETS = {
    "collision__Coll_Player_Itembox_sa1.inc": "CoreBridge.gd + terrain/item-box collision tests",
    "collision__sa2__sub_800D0A0.inc": "CoreBridge.gd + terrain_surface_smoke.gd",
    "collision__sub_800C934.inc": "CoreBridge.gd + terrain_surface_smoke.gd",
    "collision__sub_800CBBC.inc": "CoreBridge.gd + terrain_surface_smoke.gd",
    "collision__sub_800D0A0.inc": "CoreBridge.gd + terrain_surface_smoke.gd",
    "collision__sub_800D0A0_collect_rings.inc": "CoreBridge.gd + multiplayer runtime flow",
    "collision__sub_800C1E8_sa1.inc": "SA1-only collision variant; outside the SA2 product",
    "evt_mgr__ReceiveRoomEvent_ReachedStageGoal_sa1.inc": "SA1-only multiplayer event variant; outside the SA2 product",
    "item_box__Task_ItemBoxMain.inc": "CoreBridge.gd + item_box_smoke.gd",
    "mp_player__Task_CreateMultiplayerPlayer__CollectRings.inc": "CoreBridge.gd + multiplayer_flow_smoke.gd",
    "sa1_mp_player__Task_CreateMultiplayerPlayer.inc": "SA1-only multiplayer variant; outside the SA2 product",
	"rings_scatter/RingsScatterMultipak_FlippedGravity.inc": "CoreBridge.gd + scatter_ring_smoke.gd",
	"rings_scatter/RingsScatterMultipak_NormalGravity.inc": "CoreBridge.gd + scatter_ring_smoke.gd",
	"rings_scatter/RingsScatterSinglepakMain.inc": "CoreBridge.gd + scatter_ring_smoke.gd",
	"rings_scatter/RingsScatterSinglepakMain_CollectRings.inc": "CoreBridge.gd + scatter_ring_smoke.gd",
    "sa1_Task_SpotlightBeam.inc": "SA1-only spotlight variant; outside the SA2 product",
    "Task_SpotlightBeamTask.inc": "StageBackdrop.gd + SourceBackgroundProfile.gd",
}

# Present in the decompilation but not called by any SA2 translation unit;
# these are retained as source references, not active remake requirements.
OPTIONAL_UNREFERENCED = {
    "src/game/sa2/multiplayer/team_play.c": "CreateMultiplayerTeamPlayScreen has no caller in the SA2 source tree",
}


def source_files():
    return sorted(p for p in SA2.rglob("*") if p.suffix in {".c", ".cc"})


def all_source_files():
    return sorted(p for root in SOURCE_ROOTS if root.exists() for p in root.rglob("*") if p.suffix in {".c", ".cc"})


def all_assembly_files():
    return sorted(p for p in ASM_ROOT.rglob("*") if p.suffix in {".s", ".inc"})


def assembly_category_for(path: Path) -> str:
    relative = path.relative_to(ROOT).as_posix()
    if relative.startswith("asm/non_matching/game/sa1/"):
        return "asm/non_matching/game/sa1"
    if relative.startswith("asm/non_matching/game/sa2/"):
        return "asm/non_matching/game/sa2"
    if relative.startswith("asm/non_matching/game/shared/"):
        return "asm/non_matching/game/shared"
    if relative.startswith("asm/non_matching/game/math/"):
        return "asm/non_matching/game/math"
    if relative.startswith("asm/non_matching/engine/"):
        return "asm/non_matching/engine"
    if relative.startswith("asm/macros"):
        return "asm/macros"
    return "asm/virtual_console"


def all_category_for(path: Path) -> str:
    relative = path.relative_to(ROOT).as_posix()
    for prefix in sorted(ALL_TREE_TARGETS, key=len, reverse=True):
        if relative == prefix or relative.startswith(prefix + "/"):
            return prefix
    return "unclassified"


def category_for(path: Path) -> str:
    relative = path.relative_to(SA2).as_posix()
    parts = relative.split("/")
    if parts[0] in CATEGORY_TARGETS:
        return parts[0]
    if parts[0] == "stage" and len(parts) > 1:
        return "stage"
    if parts[0] in {"sound_test.c", "save.c", "title_screen.c"}:
        return parts[0]
    if parts[0] == "assets":
        return "assets"
    return "stage" if parts[0] == "stage" else "unclassified"


def main() -> int:
    files = source_files()
    categories = {}
    unclassified = []
    for path in files:
        category = category_for(path)
        categories[category] = categories.get(category, 0) + 1
        if category == "unclassified":
            unclassified.append(path.relative_to(ROOT).as_posix())

    missing_nonmatching = [name for name in NONMATCHING_TARGETS if not any(path.name == name for path in NONMATCHING.rglob(name))]
    shared_assembly_files = list((ASM_ROOT / "non_matching" / "game" / "shared").rglob("*.inc"))
    shared_assembly_names = {path.name for path in shared_assembly_files}
    shared_assembly_unmapped = [name for name in SHARED_ASSEMBLY_TARGETS if Path(name).name not in shared_assembly_names]
    all_files = all_source_files()
    all_categories = {}
    all_unclassified = []
    for path in all_files:
        category = all_category_for(path)
        all_categories[category] = all_categories.get(category, 0) + 1
        if category == "unclassified":
            all_unclassified.append(path.relative_to(ROOT).as_posix())
    assembly_files = all_assembly_files()
    assembly_categories = {}
    for path in assembly_files:
        category = assembly_category_for(path)
        assembly_categories[category] = assembly_categories.get(category, 0) + 1
    print(f"SA2_SOURCE_MODULES={len(files)}")
    print(f"ORIGINAL_C_FAMILY={len(all_files)}")
    print("ORIGINAL_C_TREES=" + ",".join(f"{k}:{all_categories.get(k, 0)}" for k in sorted(ALL_TREE_TARGETS)))
    print(f"ORIGINAL_C_UNCLASSIFIED={len(all_unclassified)}")
    print(f"ORIGINAL_ASSEMBLY_FILES={len(assembly_files)}")
    print("ORIGINAL_ASSEMBLY_TREES=" + ",".join(f"{k}:{assembly_categories.get(k, 0)}" for k in sorted(assembly_categories)))
    print("SA2_SOURCE_CATEGORIES=" + ",".join(f"{k}:{categories.get(k, 0)}" for k in sorted(CATEGORY_TARGETS)))
    print(f"SA2_UNCLASSIFIED={len(unclassified)}")
    print(f"SA2_NONMATCHING_ROUTINES={len(NONMATCHING_TARGETS)}")
    print(f"SA2_NONMATCHING_UNMAPPED={len(missing_nonmatching)}")
    print(f"SHARED_ASSEMBLY_ROUTINES={len(shared_assembly_files)}")
    print(f"SHARED_ASSEMBLY_UNMAPPED={len(shared_assembly_unmapped)}")
    print(f"SA2_OPTIONAL_UNREFERENCED={len(OPTIONAL_UNREFERENCED)}")
    if unclassified:
        print("UNCLASSIFIED:")
        print("\n".join(unclassified))
    if missing_nonmatching:
        print("MISSING_NONMATCHING_FILES:")
        print("\n".join(missing_nonmatching))
    if shared_assembly_unmapped:
        print("SHARED_ASSEMBLY_UNMAPPED_FILES:")
        print("\n".join(shared_assembly_unmapped))
    if all_unclassified:
        print("ORIGINAL_C_UNCLASSIFIED_FILES:")
        print("\n".join(all_unclassified))
    print("CATEGORY_TARGETS:")
    for category, target in sorted(CATEGORY_TARGETS.items()):
        print(f"{category} => {target}")
    print("NONMATCHING_TARGETS:")
    for source, target in sorted(NONMATCHING_TARGETS.items()):
        print(f"{source} => {target}")
    print("OPTIONAL_UNREFERENCED:")
    for source, reason in sorted(OPTIONAL_UNREFERENCED.items()):
        print(f"{source} => {reason}")
    return 1 if unclassified or missing_nonmatching or shared_assembly_unmapped or all_unclassified else 0


if __name__ == "__main__":
    raise SystemExit(main())
