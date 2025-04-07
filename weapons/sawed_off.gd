extends Weapon
@onready var attack_emitter_2: AttackEmitter = $AttackEmitter2
@export var muzzle_flash_2 : GPUParticles3D
@export var alt_recoil : Vector3
var fired_right := false
var fired_left := false

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
	camera_holder.apply_recoil(recoil)
	fired.emit()
	if muzzle_flash != null:
		muzzle_flash.emitting = true
	if muzzle_flash_2 != null:
		muzzle_flash_2.emitting = true
	await animation_player.animation_finished
	reload()

func actually_attack():
	#attack_emmiter.global_transform = fire_point.global_transform
	attack_emmiter.fire()
	attack_emitter_2.fire()

func alt_attack(input_just_pressed: bool, input_held: bool):
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
		AmmoManager.use_ammo(ammo_type, 1)
	
	if !animation_controlled_attack:
		actually_alt_attack()
	camera_holder.apply_recoil(alt_recoil)
	last_attack_time = cur_time
	animation_player.stop()
	animation_player.play("alt_attack")
	fired.emit()
	#$"AttackSounds".play()
	if muzzle_flash != null:
		muzzle_flash.emitting = true
	await animation_player.animation_finished
	if fired_right and fired_left:
		reload()


func actually_alt_attack():
	if !fired_right:
		attack_emmiter.fire()
		fired_right = true
	else:
		attack_emitter_2.fire()
		fired_left = true

func reload():
	animation_player.play("reload")
	fired_right = false
	fired_left = false
