class_name LevelBuilder
extends RefCounted

const PLATFORM_BUILDER := preload("res://scripts/core/PlatformBuilder.gd")
const ENTITY_SPAWNER := preload("res://scripts/core/EntitySpawner.gd")

const ITEM_BOX_KIND_SHIELD := 1
const ITEM_BOX_KIND_INVINCIBILITY := 2
const ITEM_BOX_KIND_ONE_UP := 3
const ITEM_BOX_KIND_SPEED_UP := 4
const ITEM_BOX_KIND_MAGNETIC_SHIELD := 5
const ITEM_BOX_KIND_RINGS_5 := 7

static func build(level_id: int, level_name: String, time_attack_boss_mode: bool, selected_level_index: int, enemy_speed: float) -> LevelState:
	var level := LevelState.new()
	level.level_id = level_id
	level.name = level_name
	level.spawn_x = 180.0
	level.spawn_y = 460.0
	level.ground_y = 460.0
	level.min_x = 0.0
	level.max_x = 2400.0
	level.min_y = 0.0
	level.max_y = 720.0
	PLATFORM_BUILDER.add_platform(level, 200.0, 460.0, 380.0, 32.0)
	PLATFORM_BUILDER.add_platform(level, 620.0, 420.0, 220.0, 24.0)
	PLATFORM_BUILDER.add_platform(level, 930.0, 360.0, 220.0, 24.0)
	PLATFORM_BUILDER.add_platform(level, 1250.0, 320.0, 180.0, 24.0)
	PLATFORM_BUILDER.add_platform(level, 1490.0, 390.0, 260.0, 24.0)
	PLATFORM_BUILDER.add_platform(level, 1830.0, 340.0, 220.0, 24.0)

	if level_id == 0:
		ENTITY_SPAWNER.add_ring_line(level, 280.0, 384.0, 5, 54.0)
		ENTITY_SPAWNER.add_spring(level, 560.0, 448.0)
		ENTITY_SPAWNER.add_ring_line(level, 720.0, 350.0, 4, 52.0)
		ENTITY_SPAWNER.add_enemy(level, 980.0, 444.0, 900.0, 1040.0, enemy_speed)
		ENTITY_SPAWNER.add_ring_line(level, 980.0, 306.0, 5, 42.0)
		ENTITY_SPAWNER.add_spring(level, 1300.0, 448.0)
		ENTITY_SPAWNER.add_item_box(level, 1450.0, 270.0, 10)
		ENTITY_SPAWNER.add_item_box(level, 1180.0, 300.0, 0, ITEM_BOX_KIND_SPEED_UP)
		ENTITY_SPAWNER.add_item_box(level, 1740.0, 280.0, 0, ITEM_BOX_KIND_ONE_UP)
		ENTITY_SPAWNER.add_item_box(level, 2050.0, 270.0, 0, ITEM_BOX_KIND_INVINCIBILITY)
		ENTITY_SPAWNER.add_ring_line(level, 1340.0, 286.0, 4, 40.0)
		ENTITY_SPAWNER.add_checkpoint(level, 1610.0, 448.0)
		ENTITY_SPAWNER.add_whirlwind(level, 1660.0, 250.0, 150.0, 260.0)
		ENTITY_SPAWNER.add_fan(level, 1100.0, 310.0, 220.0, 180.0, 1.0)
		PLATFORM_BUILDER.add_moving_platform(level, 1080.0, 280.0, 140.0, 18.0, 1, 44.0, 1.8)
		ENTITY_SPAWNER.add_propeller(level, 1910.0, 300.0)
		ENTITY_SPAWNER.add_enemy(level, 1760.0, 334.0, 1700.0, 1850.0, enemy_speed)
		ENTITY_SPAWNER.add_buzzer(level, 1120.0, 260.0, 1060.0, 1190.0)
		ENTITY_SPAWNER.add_balloon(level, 1880.0, 230.0, 1800.0, 1960.0)
		ENTITY_SPAWNER.add_bullet_buzzer(level, 2100.0, 210.0)
		ENTITY_SPAWNER.add_star(level, 2180.0, 350.0)
		ENTITY_SPAWNER.add_kiki(level, 1520.0, 250.0)
		ENTITY_SPAWNER.add_ring_line(level, 1910.0, 300.0, 4, 42.0)
		ENTITY_SPAWNER.add_special_ring(level, 330.0, 340.0)
		ENTITY_SPAWNER.add_special_ring(level, 760.0, 300.0)
		ENTITY_SPAWNER.add_special_ring(level, 1010.0, 260.0)
		ENTITY_SPAWNER.add_special_ring(level, 1370.0, 240.0)
		ENTITY_SPAWNER.add_special_ring(level, 1570.0, 340.0)
		ENTITY_SPAWNER.add_special_ring(level, 1810.0, 280.0)
		ENTITY_SPAWNER.add_special_ring(level, 2010.0, 260.0)
		if time_attack_boss_mode:
			ENTITY_SPAWNER.add_boss_for_level(level, 2180.0, 320.0, selected_level_index)
		else:
			ENTITY_SPAWNER.add_goal(level, 2280.0, 360.0)
		ENTITY_SPAWNER.add_trapped_animal(level, 2210.0, 360.0, selected_level_index % 3)
	else:
		ENTITY_SPAWNER.add_ring_line(level, 250.0, 402.0, 4, 52.0)
		ENTITY_SPAWNER.add_ring_line(level, 500.0, 370.0, 5, 38.0)
		ENTITY_SPAWNER.add_enemy(level, 640.0, 414.0, 580.0, 760.0, enemy_speed)
		ENTITY_SPAWNER.add_spring(level, 680.0, 448.0)
		PLATFORM_BUILDER.add_platform(level, 820.0, 300.0, 160.0, 20.0)
		PLATFORM_BUILDER.add_moving_platform(level, 980.0, 300.0, 150.0, 18.0, 0, 72.0, 1.4, 0.8)
		ENTITY_SPAWNER.add_ring_line(level, 860.0, 252.0, 4, 36.0)
		ENTITY_SPAWNER.add_checkpoint(level, 880.0, 448.0)
		ENTITY_SPAWNER.add_spikes(level, 1020.0, 448.0, 48.0, 20.0)
		ENTITY_SPAWNER.add_spring(level, 1120.0, 448.0)
		ENTITY_SPAWNER.add_item_box(level, 1450.0, 250.0, 0, ITEM_BOX_KIND_SHIELD)
		ENTITY_SPAWNER.add_item_box(level, 1600.0, 250.0, 0, ITEM_BOX_KIND_MAGNETIC_SHIELD)
		ENTITY_SPAWNER.add_item_box(level, 1080.0, 270.0, 0, ITEM_BOX_KIND_RINGS_5)
		ENTITY_SPAWNER.add_enemy(level, 1260.0, 334.0, 1200.0, 1380.0, enemy_speed)
		ENTITY_SPAWNER.add_koura(level, 1480.0, 320.0, 1400.0, 1570.0)
		ENTITY_SPAWNER.add_ring_line(level, 1340.0, 282.0, 6, 36.0)
		ENTITY_SPAWNER.add_special_ring(level, 300.0, 350.0)
		ENTITY_SPAWNER.add_special_ring(level, 540.0, 320.0)
		ENTITY_SPAWNER.add_special_ring(level, 880.0, 210.0)
		ENTITY_SPAWNER.add_special_ring(level, 1060.0, 340.0)
		ENTITY_SPAWNER.add_special_ring(level, 1280.0, 280.0)
		ENTITY_SPAWNER.add_special_ring(level, 1430.0, 240.0)
		ENTITY_SPAWNER.add_special_ring(level, 1510.0, 280.0)
		if time_attack_boss_mode:
			ENTITY_SPAWNER.add_boss_for_level(level, 1520.0, 300.0, selected_level_index)
		else:
			ENTITY_SPAWNER.add_goal(level, 1600.0, 340.0)
		ENTITY_SPAWNER.add_trapped_animal(level, 1540.0, 340.0, selected_level_index % 3)

	return level
