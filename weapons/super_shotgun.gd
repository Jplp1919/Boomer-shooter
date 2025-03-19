extends Weapon


func attack(input_just_pressed: bool, input_held: bool):
	if !automatic and !input_just_pressed:
		return
	if automatic and !input_held:
		return
	
	if AmmoManager.get_ammo(ammo_type) <= 1:
		if input_just_pressed:
			out_of_ammo.emit()
			if has_node("OutOfAmmoSound"):
				$"OutOfAmmoSound".play()
		return
	
	var cur_time = Time.get_ticks_msec() / 1000.0
	if cur_time - last_attack_time < attack_rate:
		return
	
	if ammo_type != AmmoType.NONE:
		AmmoManager.use_ammo(ammo_type, 2)
	
	if !animation_controlled_attack:
		actually_attack()
	last_attack_time = cur_time
	animation_player.stop()
	animation_player.play("attack")
	
	fired.emit()
	if muzzle_flash != null:
		muzzle_flash.emitting = true
