extends Area3D

@onready var health_manager: Node3D = %HealthManager
@onready var weapon_manager: Node3D = %WeaponManager
#@onready var pickup_info: Label = %PickupInfo

#@onready var ammo_sounds = {
	#Pickup.WEAPONS.MACHINE_GUN: $PickupMGAmmo,
	#Pickup.WEAPONS.SHOTGUN: $PickupSGAmmo,
	#Pickup.WEAPONS.MAGNUM: $PickupMAmmo,
	#Pickup.WEAPONS.CROC_HEAD: $PickupCrocAmmo
#}

func _ready() -> void:
	area_entered.connect(on_area_enter)
	

func on_area_enter(pickup: Area3D):
	var delete_on_pickup = true
	if pickup is Pickup:
		match pickup.pickup_type:
			Pickup.PICKUP_TYPES.HEALTH:
				if health_manager.cur_health < health_manager.max_health:
					health_manager.heal(pickup.pickup_amnt)
					#$PickupHealth.play()
				else:
					delete_on_pickup = false
			Pickup.PICKUP_TYPES.WEAPON:
				var weapon : Weapon = weapon_manager.get_weapon_from_pickup_type(pickup.weapon_type)
				weapon_manager.enable_weapon(weapon)
				if AmmoManager.get_ammo(weapon.ammo_type) <  AmmoManager.get_max_ammo(weapon.ammo_type):
					AmmoManager.add_ammo(weapon.ammo_type, pickup.pickup_amnt)
					if weapon_manager.cur_weapon.ammo_type == weapon.ammo_type:
						weapon.update_ammo()
					#weapon.add_ammo(pickup.pickup_amnt)
				#ammo_sounds[pickup.weapon_type].play()
			Pickup.PICKUP_TYPES.AMMO:
				var weapon : Weapon = weapon_manager.get_weapon_from_pickup_type(pickup.weapon_type)
				if AmmoManager.get_ammo(weapon.ammo_type) < AmmoManager.get_max_ammo(weapon.ammo_type):
					AmmoManager.add_ammo(weapon.ammo_type, pickup.pickup_amnt)
					if weapon_manager.cur_weapon.ammo_type == weapon.ammo_type:
						weapon.update_ammo()
				#ammo_sounds[pickup.weapon_type].play()
	if delete_on_pickup:
		#pickup_info.on_pickup(pickup)
		pickup.pickup()
