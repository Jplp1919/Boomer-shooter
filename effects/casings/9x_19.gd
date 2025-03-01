extends Node3D

@export var eject_speed := 5.0
@export var gravity := 9.8
@export var destroy_delay := 1.2
@export var spin_speed := 180.0

@onready var player = get_tree().get_first_node_in_group("player")

var velocity := Vector3.ZERO
var elapsed_time := 0.0

func _ready():
	var player_right = player.global_transform.basis.x
	
	velocity = (Vector3.UP * 2 + player_right).normalized() * eject_speed
	await get_tree().create_timer(destroy_delay).timeout
	queue_free()

func _process(delta):
	velocity.y -= gravity * delta
	global_translate(velocity * delta)
	rotate_x(deg_to_rad(spin_speed * delta))
