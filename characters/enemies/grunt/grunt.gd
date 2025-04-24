extends Enemy

class_name Grunt
@onready var attack_emitter_kick: AttackEmitter = $AttackEmitterKick
@export var kick_range = 2.0
@export var alert_stagger_time = 1.5

@export var retreat_distance = 15.0 
@export var min_height_difference = 5


func _ready():
	var hitboxes = find_children("*", "HitBox")
	for hitbox in hitboxes:
		hitbox.on_hurt.connect(health_manager.hurt)
	health_manager.died.connect(set_state.bind(STATES.DEAD))
	health_manager.gibbed.connect(queue_free)
	
	hitboxes.append(self)
	attack_emitter.set_bodies_to_exclude(hitboxes)
	attack_emitter_kick.set_bodies_to_exclude(hitboxes)
	attack_emitter.set_damage(damage)
	set_state(STATES.IDLE) 
	

func alert():
	if not cur_state in [STATES.ATTACK, STATES.DEAD]:
		#$AlertSound.play()
		ai_character_mover.set_facing_dir(player.global_position -global_position)
		await get_tree().create_timer(alert_stagger_time).timeout
		set_state(STATES.ATTACK)
		alert_nearby_enemies()


func process_attack_state(delta: float) -> void:
	var attacking = animation_player.current_animation == "attack"
	var vec_to_player = player.global_position -global_position
	var has_los= vision_manager.can_see_target(player)
	var facing_target = vision_manager.is_facing_target(player)
	var vertical_distance = vec_to_player.y
	#print("Can see player: ", has_los)
	#print("Facing the player: ", facing_target)
	if vec_to_player.length() <= attack_range and !staggered and has_los:
		ai_character_mover.stop_moving()
		if !attacking and has_los and facing_target:
			start_attack()
		elif !attacking:
			ai_character_mover.set_facing_dir(vec_to_player)
	elif vertical_distance > min_height_difference:
		print("here")
		var retreat_dir = -Vector3(vec_to_player.x, 0, vec_to_player.z).normalized()
		var retreat_pos = global_position + retreat_dir * retreat_distance
		ai_character_mover.move_to_point(retreat_pos)
	elif !attacking and !staggered:
		ai_character_mover.set_facing_dir(ai_character_mover.move_dir)
		ai_character_mover.move_to_point(player.global_position)
		animation_player.play("walk", -1, 2.0)

#func process_attack_state(delta: float) -> void:
	#var attacking = animation_player.current_animation == "attack"
	#var vec_to_player = player.global_position -global_position
	#var facing_target = vision_manager.is_facing_target(player)
	#
	#if vec_to_player.length() <= attack_range and !staggered and facing_target:
		#ai_character_mover.stop_moving()
		#if !attacking and facing_target:
			#start_attack()
		#elif !attacking:
			#ai_character_mover.set_facing_dir(vec_to_player)
	#elif !attacking and !staggered:
		#ai_character_mover.set_facing_dir(ai_character_mover.move_dir)
		#ai_character_mover.move_to_point(player.global_position)
		#animation_player.play("walk", -1, 2.0)


func start_attack():
	if disarmed_r:
		damage = kick_damage
		attack_range = kick_range
		attack_emitter_kick.set_damage(damage)
		animation_player.play("kick", -1, attack_speed_modifier)
	else:
		animation_player.play("attack", -1, attack_speed_modifier)
	var target_pos = player.global_position + Vector3.UP * 1.5
	var dir_to_player = attack_emitter.global_position.direction_to(target_pos)
	if dir_to_player.is_equal_approx(Vector3.UP) or dir_to_player.is_equal_approx(Vector3.DOWN):
		attack_emitter.look_at(target_pos, Vector3.RIGHT)
	else:
		attack_emitter.look_at(target_pos)



func do_kick(): #called from animation
	attack_emitter_kick.fire()
