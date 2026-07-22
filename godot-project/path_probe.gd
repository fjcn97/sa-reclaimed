extends SceneTree

func _init() -> void:
	var path := ProjectSettings.globalize_path("res://../data/sa2/maps/zone_1/act_1/entities/rings.csv")
	print(FileAccess.file_exists(path))
	print(path)
	quit()
