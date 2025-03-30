extends Grunt

var pickup_scene: PackedScene = preload("res://pickups/792x_57_pickup.tscn")

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
				animation_player.play("dismembered_head", 0.2)
			else:
				animation_player.play("die", 0.2)
			collision_layer = 0
			collision_mask = 1
			ai_character_mover.stop_moving()

func drop_pickup():
	if randf() <= 0.7:
		var pickup = pickup_scene.instantiate()
		get_parent().add_child(pickup)
		pickup.global_position = global_position
