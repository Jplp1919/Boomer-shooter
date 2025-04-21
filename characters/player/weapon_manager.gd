extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var weapons = $"Weapons".get_children()
@onready var nearby_enemies_alert_area_small: Area3D = $NearbyEnemiesAlertAreaSmall
@onready var nearby_enemies_alert_area_large: Area3D = $NearbyEnemiesAlertAreaLarge
@onready var los_ray_cast_3d: RayCast3D = $LOSRayCast3D

var weapons_unlocked = []
var cur_slot = 0
var cur_weapon = null


@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	for weapon in weapons:
		if !weapon.silent_weapon:
			weapon.fired.connect(alert_enemies_on_fired)
		if weapon.has_method("set_bodies_to_exclude"):
			weapon.set_bodies_to_exclude([get_parent().get_parent().get_parent()])
	disable_all_weapons()
	for _i in range(weapons.size()):
		#weapons_unlocked.append(true) #unlocks all weapons, for test purposes
		weapons_unlocked.append(false) #locks all weapons by default
		weapons_unlocked[0] = true #sword unlocks by default
	switch_to_weapon_slot(0)


func attack(input_just_pressed:bool, input_held:bool):
	if cur_weapon is Weapon:
		cur_weapon.attack(input_just_pressed, input_held)

func alt_attack(input_just_pressed:bool, input_held:bool):
	if cur_weapon is Weapon:
		cur_weapon.alt_attack(input_just_pressed, input_held)

func enable_weapon(weapon: Weapon):
	if weapon == null:
		return
	var weapon_ind = weapon.get_index()
	var weapon_unlocked = weapons_unlocked[weapon_ind]
	weapons_unlocked[weapon_ind] = true
	if !weapon_unlocked:
		switch_to_weapon_slot(weapon_ind)

func disable_all_weapons():
	for weapon in weapons:
		if weapon.has_method("set_active"):
			weapon.set_active(false)
		else:
			weapon.hide()

func switch_to_previous_weapon():
	for i in range(weapons.size()):
		var wrapped_ind = wrapi(cur_slot -1 -i, 0, weapons.size())
		if switch_to_weapon_slot(wrapped_ind):
			break

func switch_to_next_weapon():
	for i in range(weapons.size()):
		var wrapped_ind = wrapi(cur_slot +1 +i, 0, weapons.size())
		if switch_to_weapon_slot(wrapped_ind):
			break

func switch_to_weapon_slot(slot_ind: int)->bool:
	if slot_ind >= weapons.size() or slot_ind < 0:
		return false
	if weapons_unlocked.size() == 0 or !weapons_unlocked[slot_ind]:
		return false
	disable_all_weapons()
	cur_slot = slot_ind 
	cur_weapon = weapons[cur_slot]
	if cur_weapon.has_method("set_active"):
		cur_weapon.set_active(true)
		cur_weapon.play_equip_sound()
	else:
		cur_weapon.show()
	
	return true

func update_animation(velocity: Vector3, grounded: bool):
	if cur_weapon is Weapon and !cur_weapon.is_idle():
		animation_player.play("RESET")
	elif !grounded or velocity.length() < 5.0:
		animation_player.play("RESET", 0.3)
	else:
		animation_player.play("moving", 0.3)

func alert_enemies_on_fired():
	for enemy in nearby_enemies_alert_area_small.get_overlapping_bodies():
		if enemy is Enemy:
			enemy.alert()
	for enemy in nearby_enemies_alert_area_large.get_overlapping_bodies():
		if enemy is Enemy:
			los_ray_cast_3d.enabled = true
			los_ray_cast_3d.target_position = los_ray_cast_3d.to_local(enemy.vision_manager.global_position)
			los_ray_cast_3d.force_raycast_update()
			if !los_ray_cast_3d.is_colliding():
				enemy.alert()
			los_ray_cast_3d.enabled = false

func get_weapon_from_pickup_type(weapon_type : Pickup.WEAPONS) -> Weapon:
	match weapon_type:
		Pickup.WEAPONS.TRENCH_GUN:
			return $Weapons/Shotgun
		Pickup.WEAPONS.MACHINE_GUN:
			return $Weapons/Machinegun
		Pickup.WEAPONS.SUPER_SHOTGUN:
			return $"Weapons/Sawed-Off"
		Pickup.WEAPONS.RIFLE:
			return $Weapons/Rifle
		Pickup.WEAPONS.PLASMA_PISTOL:
			return $"Weapons/Plasma Pistol"
		Pickup.WEAPONS.LIGHTNING_GUN:
			return $"Weapons/Lightning Gun"

	return null
