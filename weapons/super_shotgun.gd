extends Weapon


func attack(input_just_pressed:bool, input_held:bool):
	if !automatic and !input_just_pressed:
		return
	if automatic and !input_held:
		return
	
	if ammo == 0:
		if input_just_pressed:
			out_of_ammo.emit()
			if has_node("OufOfAmmoSound"):
				$"OufOfAmmoSound".play()
		return
	var cur_time = Time.get_ticks_msec() / 1000.0
	if cur_time - last_attack_time < attack_rate:
		return
	
	if ammo > 0:
		ammo -= 2
	if !animation_controlled_attack:
		actually_attack()
	last_attack_time = cur_time
	animation_player.stop()
	animation_player.play("attack")
	
	fired.emit()
	if muzzle_flash != null:
		#$Graphics/MuzzleFlash.flash()
		muzzle_flash.emitting = true
