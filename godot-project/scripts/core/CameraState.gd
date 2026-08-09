# CameraState.gd
# Camera position and stage clamp snapshot exposed by the gameplay bridge.
class_name CameraState
extends RefCounted

var x: float = 0.0
var y: float = 0.0
var min_x: float = 0.0
var max_x: float = 0.0
var min_y: float = 0.0
var max_y: float = 0.0
