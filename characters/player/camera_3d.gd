extends Camera3D

@onready var camera_3d: Camera3D = $"../../../Camera3D"

func _process(delta: float) -> void:
	global_transform = camera_3d.global_transform
