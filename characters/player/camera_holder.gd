extends Node3D

@export var snappiness: float = 10.0
@export var return_speed: float = 5.0

var _active_rotation: Vector3
var _target_rotation: Vector3

func _process(delta: float) -> void:
	_target_rotation = _target_rotation.move_toward(Vector3.ZERO, return_speed * delta)
	_active_rotation = _active_rotation.lerp(_target_rotation, snappiness * delta)
	rotation = _active_rotation
	


func apply_recoil(strength: Vector3) -> void:
	_target_rotation += Vector3(
		strength.x,
		randf_range(-strength.y, strength.y),
		randf_range(-strength.z, strength.z))
