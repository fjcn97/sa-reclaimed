# SoundTestCatalog.gd
# Immutable sound-test metadata shared by the options screen and bridge state.
class_name SoundTestCatalog
extends RefCounted

static func tracks() -> Array:
	return [
		{"number": 1, "name": "OPENING"}, {"number": 2, "name": "TITLE"},
		{"number": 3, "name": "CHARACTER SELECT"}, {"number": 4, "name": "ZONE SELECT"},
		{"number": 9, "name": "ZONE 1-1"}, {"number": 10, "name": "ZONE 1-2"},
		{"number": 11, "name": "ZONE 2-1"}, {"number": 12, "name": "ZONE 2-2"},
		{"number": 13, "name": "ZONE 3-1"}, {"number": 14, "name": "ZONE 3-2"},
		{"number": 15, "name": "ZONE 4-1"}, {"number": 16, "name": "ZONE 4-2"},
		{"number": 17, "name": "ZONE 5-1"}, {"number": 18, "name": "ZONE 5-2"},
		{"number": 19, "name": "ZONE 6-1"}, {"number": 20, "name": "ZONE 6-2"},
		{"number": 21, "name": "ZONE 7-1"}, {"number": 22, "name": "ZONE 7-2"},
		{"number": 23, "name": "FINAL ZONE"}, {"number": 27, "name": "BOSS"},
		{"number": 28, "name": "BOSS-PINCH"}, {"number": 29, "name": "KNUCKLES BOSS"},
		{"number": 30, "name": "7-BOSS"}, {"number": 31, "name": "7-BOSS-PINCH"},
		{"number": 32, "name": "FINAL BOSS"}, {"number": 33, "name": "FINAL BOSS-PINCH"},
		{"number": 55, "name": "ACT CLEAR"}, {"number": 56, "name": "BOSS CLEAR"},
		{"number": 57, "name": "FINAL CLEAR"}, {"number": 34, "name": "GAME OVER"},
		{"number": 25, "name": "UNRIVAL"}, {"number": 26, "name": "DROWN"},
		{"number": 61, "name": "1_UP"}, {"number": 38, "name": "DEMO 1"},
		{"number": 39, "name": "DEMO 2"}, {"number": 5, "name": "ZONE SELECT 2"},
		{"number": 42, "name": "IN SP STAGE"}, {"number": 43, "name": "SP STAGE"},
		{"number": 44, "name": "SP STAGE-PINCH"}, {"number": 45, "name": "ACHIEVEMENT"},
		{"number": 46, "name": "SP CLEAR"}, {"number": 47, "name": "SP RESULT 1"},
		{"number": 48, "name": "SP RESULT 2"}, {"number": 49, "name": "SP RESULT 3"},
		{"number": 35, "name": "FINAL ENDING"}, {"number": 37, "name": "STAFF ROLL"},
		{"number": 67, "name": "MESSAGE"}, {"number": 7, "name": "TIMEATTACK 1"},
		{"number": 59, "name": "TIMEATTACK 2"}, {"number": 60, "name": "TIMEATTACK 3"},
		{"number": 8, "name": "OPTIONS"}, {"number": 54, "name": "VS WAIT"},
		{"number": 50, "name": "VS 1"}, {"number": 51, "name": "VS 2"},
		{"number": 53, "name": "VS 3"}, {"number": 52, "name": "VS 4"},
		{"number": 63, "name": "VS END"},
	]

static func bonus_tracks() -> Array:
	return [
		{"number": 6, "name": "ZONE SELECT 3"}, {"number": 40, "name": "EXTRA DEMO 1"},
		{"number": 41, "name": "EXTRA DEMO 2"}, {"number": 24, "name": "EXTRA ZONE"},
		{"number": 58, "name": "EXTRA CLEAR"}, {"number": 36, "name": "EXTRA ENDING"},
	]

static func completed_order() -> Array:
	return [
		1, 2, 3, 4, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,
		27, 28, 29, 30, 31, 32, 33, 55, 56, 57, 34, 25, 26, 61, 38, 39, 5,
		42, 43, 44, 45, 46, 47, 48, 49, 35, 37, 67, 7, 59, 60, 8, 54, 50,
		51, 53, 52, 63, 6, 40, 41, 24, 58, 36,
	]

static func tempo_for_song(song_number: int) -> float:
	const tempos: Array[float] = [
		17.5, 17.5, 16.0, 16.0625, 16.6875, 16.25, 15.25, 15.0,
		20.75, 20.75, 21.0234375, 20.4375, 16.842285, 16.842285, 19.0, 27.0,
		17.8125, 20.0, 20.5, 21.5, 20.125, 21.5, 20.75, 21.5,
		16.8203125, 19.25, 21.25, 20.0, 20.5, 22.5, 23.6875, 18.0,
		19.125, 16.0, 17.0, 22.5, 19.0, 16.0, 14.75, 18.875,
		19.0625, 16.0, 21.0, 22.0, 21.0, 20.0, 26.3125, 18.0,
		23.75, 20.8125, 20.0, 21.0, 16.875, 20.0, 18.0, 19.0,
		21.0, 18.0, 18.0, 21.0, 16.0, 16.0, 16.0, 16.0,
		18.0, 16.0, 20.0,
	]
	return tempos[clampi(song_number - 1, 0, tempos.size() - 1)]
