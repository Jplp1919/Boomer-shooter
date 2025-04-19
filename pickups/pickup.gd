class_name Pickup
extends Area3D

enum PICKUP_TYPES {HEALTH, WEAPON, AMMO}

enum WEAPONS {TRENCH_GUN, MACHINE_GUN, SUPER_SHOTGUN, RIFLE, PLASMA_PISTOL, LIGHTNING_GUN}

@export var pickup_type = PICKUP_TYPES.HEALTH
@export var weapon_type = WEAPONS.MACHINE_GUN
@export var pickup_amnt  = 20

func pickup():
	queue_free()
