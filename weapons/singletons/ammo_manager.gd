extends Node



var ammo_pools = {
	Weapon.AmmoType.NONE: -1,
	Weapon.AmmoType._9X19: 0,
	Weapon.AmmoType._8GA: 0,
	Weapon.AmmoType._792X57: 0,
	Weapon.AmmoType.ROCKET: 0,
	Weapon.AmmoType._45_70: 0
}

var max_ammo = {
	Weapon.AmmoType.NONE: 0,
	Weapon.AmmoType._9X19: 300,
	Weapon.AmmoType._8GA: 80,
	Weapon.AmmoType._792X57: 500,
	Weapon.AmmoType.ROCKET: 50,
	Weapon.AmmoType._45_70: 50
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
	ammo_pools[Weapon.AmmoType._9X19] = 50
	ammo_pools[Weapon.AmmoType._8GA] = 10
	ammo_pools[Weapon.AmmoType._792X57] = 100
	ammo_pools[Weapon.AmmoType.ROCKET] = 5
	ammo_pools[Weapon.AmmoType._45_70] = 10
