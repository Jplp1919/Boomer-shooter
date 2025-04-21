extends Weapon

@export var alt_recoil : Vector3
@export var alt_attack_rate = 0.8



func alt_attack(input_just_pressed: bool, input_held: bool):

	if !input_held:
		return
	
	if AmmoManager.get_ammo(ammo_type) == 0:
		if input_just_pressed:
			out_of_ammo.emit()
			$OutOfAmmoSounds.play()
		return
	
	var cur_time = Time.get_ticks_msec() / 1000.0
	if cur_time - last_attack_time < alt_attack_rate:
		return
	
	if ammo_type != AmmoType.NONE:
		AmmoManager.use_ammo(ammo_type, 1)
	
	if !animation_controlled_attack:
		actually_attack()
	camera_holder.apply_recoil(alt_recoil)
	last_attack_time = cur_time
	animation_player.stop()
	animation_player.play("alt_attack")
	fired.emit()
	$"AttackSounds".play()
	if muzzle_flash != null:
		muzzle_flash.emitting = true

func actually_attack():
	attack_emmiter.global_transform = fire_point.global_transform
	attack_emmiter.fire()

func cock():
	$CockingSounds.play()

func alt_cock():
	$AltCockingSounds.play()
