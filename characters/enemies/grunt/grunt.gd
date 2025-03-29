extends Enemy

class_name Grunt

func alert():
	if not cur_state in [STATES.ATTACK, STATES.DEAD]:
		#$AlertSound.play()
		ai_character_mover.set_facing_dir(player.global_position -global_position)
		await get_tree().create_timer(1.5).timeout
		set_state(STATES.ATTACK)
		alert_nearby_enemies()


func process_attack_state(delta: float) -> void:
	var attacking = animation_player.current_animation == "attack"
	var vec_to_player = player.global_position -global_position
	var facing_target = vision_manager.is_facing_target(player)
	
	if vec_to_player.length() <= attack_range and !staggered and facing_target:
		ai_character_mover.stop_moving()
		if !attacking and facing_target:
			start_attack()
		elif !attacking:
			ai_character_mover.set_facing_dir(vec_to_player)
	elif !attacking and !staggered:
		ai_character_mover.set_facing_dir(ai_character_mover.move_dir)
		ai_character_mover.move_to_point(player.global_position)
		animation_player.play("walk", -1, 2.0)

func start_attack():
	super()
	var target_pos = player.global_position + Vector3.UP * 1.5
	var dir_to_player = attack_emitter.global_position.direction_to(target_pos)
	if dir_to_player.is_equal_approx(Vector3.UP) or dir_to_player.is_equal_approx(Vector3.DOWN):
		attack_emitter.look_at(target_pos, Vector3.RIGHT)
	else:
		attack_emitter.look_at(target_pos)
