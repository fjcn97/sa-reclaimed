# ProfileCatalog.gd
# Immutable defaults for profile and button-configuration screens.
class_name ProfileCatalog
extends RefCounted

static func name_characters() -> Array:
	return [
		"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
		"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
		"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "-", "!", "?", " ", "@", ".", "_", "/",
	]

static func default_button_bindings() -> Array:
	return ["JUMP", "ATTACK", "TRICK"]
