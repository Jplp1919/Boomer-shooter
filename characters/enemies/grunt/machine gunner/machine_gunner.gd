extends Grunt

var pickup_scene: PackedScene = preload("res://pickups/792x_57_pickup.tscn")
var weapon_pickup_scene: PackedScene = preload("res://pickups/machinegun_pickup.tscn")
var delete_meshes = false
@export var meshes_to_destroy: Array[MeshInstance3D]

func set_state(state: STATES):
	if cur_state == STATES.DEAD:
		return
	cur_state = state
	match cur_state:
		STATES.ATTACK:
			print("attack state set")
		STATES.IDLE:
			animation_player.play("idle")
		STATES.STAGGERED:
			if disarmed_l:
				animation_player.play("dismembered_left_arm")
				disarmed_l = false
			else:
				animation_player.play("stagger")
		STATES.DEAD:
			drop_pickup()
			if beheaded:
				var chance = randf()
				if chance <= 0.5:
					animation_player.play("dismembered_head", 0.2)
				else:
					animation_player.play("die", 0.2)
			else:
				animation_player.play("die", 0.2)
			collision_layer = 0
			collision_mask = 1
			ai_character_mover.stop_moving()

func drop_pickup():
	var chance = randf()  # Random value between 0.0 and 1.0
	if chance <= 0.7:  # 70% chance (0.0 - 0.7)
		spawn_pickup(pickup_scene)
	elif chance <= 0.9:  # 20% chance (0.7 - 0.9)
		spawn_pickup(weapon_pickup_scene)
		delete_meshes = true
	# else (0.9 - 1.0): 10% chance, do nothing
	if delete_meshes and meshes_to_destroy:
		destroy_meshes()

func spawn_pickup(scene: PackedScene):
	var pickup = scene.instantiate()
	get_parent().add_child(pickup)
	pickup.global_position = global_position

func destroy_meshes():
	for mesh in meshes_to_destroy:
		if mesh:
			mesh.queue_free()
