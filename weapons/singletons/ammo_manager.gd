extends Node



var ammo_pools = {
	Weapon.AmmoType.NONE: -1,
	Weapon.AmmoType._12GA: 0,
	Weapon.AmmoType._792X57: 0,
	Weapon.AmmoType.ROCKET: 0
}

var max_ammo = {
	Weapon.AmmoType.NONE: 0,
	Weapon.AmmoType._12GA: 80,
	Weapon.AmmoType._792X57: 500,
	Weapon.AmmoType.ROCKET: 50
}

func _ready():
	reset_ammo()

func get_max_ammo(ammo_type: Weapon.AmmoType) -> int:
	return max_ammo.get(ammo_type, 0)

func get_ammo(ammo_type: Weapon.AmmoType) -> int:
	return ammo_pools.get(ammo_type, 0)

func use_ammo(ammo_type: Weapon.AmmoType, amount: int):
	if ammo_type in ammo_pools:
		ammo_pools[ammo_type] = max(ammo_pools[ammo_type] - amount, 0)

func add_ammo(ammo_type: Weapon.AmmoType, amount: int):
	if ammo_type in ammo_pools:
		ammo_pools[ammo_type] = min(ammo_pools[ammo_type] + amount, max_ammo[ammo_type])

func reset_ammo():
	ammo_pools[Weapon.AmmoType._12GA] = 0
	ammo_pools[Weapon.AmmoType._792X57] = 0
	ammo_pools[Weapon.AmmoType.ROCKET] = 5
