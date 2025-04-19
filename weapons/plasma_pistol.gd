extends Weapon

@onready var sparks: GPUParticles3D = $Graphics/Sparks
@onready var trails: Node3D = $Graphics/Trails


func attack(input_just_pressed: bool, input_held: bool):
	if !automatic and !input_just_pressed:
		return
	if automatic and !input_held:
		return
	
	if AmmoManager.get_ammo(ammo_type) == 0:
		if input_just_pressed:
			out_of_ammo.emit()
			if out_of_ammo_sound:
				ouf_of_ammo_sound_player.stream = out_of_ammo_sound
				ouf_of_ammo_sound_player.play()
		return
	
	var cur_time = Time.get_ticks_msec() / 1000.0
	if cur_time - last_attack_time < attack_rate:
		return
	
	if ammo_type != AmmoType.NONE:
		AmmoManager.use_ammo(ammo_type, 5)
	
	if !animation_controlled_attack:
		actually_attack()
	camera_holder.apply_recoil(recoil)
	last_attack_time = cur_time
	animation_player.stop()
	
	animation_player.play("attack")
	fired.emit()
	#$"AttackSounds".play()
	sparks.emitting = true
	trails.show()
	await get_tree().create_timer(0.1).timeout
	trails.hide()
