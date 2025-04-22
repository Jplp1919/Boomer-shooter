extends Weapon

@onready var sparks: GPUParticles3D = $Graphics/Sparks
@onready var lightning: Node3D = $Graphics/Lightning

var is_attacking := false

func _ready() -> void:
	attack_emmiter.set_damage(damage)
	sparks.local_coords = true

func attack(input_just_pressed: bool, input_held: bool):
	if !automatic and !input_just_pressed:
		return
	if automatic and !input_held:
		lightning.hide()  
		is_attacking = false
		return

	if is_attacking:
		return
	
	is_attacking = true
	lightning.show()
	
	if AmmoManager.get_ammo(ammo_type) == 0:
		if input_just_pressed:
			out_of_ammo.emit()
			$OutOfAmmoSounds.play()
		lightning.hide()
		is_attacking = false
		return
	
	var cur_time = Time.get_ticks_msec() / 1000.0
	if cur_time - last_attack_time < attack_rate:
		lightning.hide()
		is_attacking = false
		return
	
	while input_held and is_attacking:
		if ammo_type != AmmoType.NONE:
			AmmoManager.use_ammo(ammo_type, 5)
		
		if !animation_controlled_attack:
			actually_attack()
		
		camera_holder.apply_recoil(recoil)
		last_attack_time = Time.get_ticks_msec() / 1000.0
		animation_player.play("attack")
		fired.emit()
		$"AttackSounds".play()
		sparks.emitting = true
		
		await get_tree().create_timer(attack_rate).timeout
		if AmmoManager.get_ammo(ammo_type) == 0:
			break
	
	lightning.hide()
	is_attacking = false
