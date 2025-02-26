extends AttackEmitter

const PROJECTILES = [
	preload("res://weapons/projectiles/rocket.tscn"),
	preload("res://weapons/projectiles/bullet.tscn")
]

enum PROJECTILE_TYPE{
	ROCKET,
	BULLET
}

@export var projectile_type : PROJECTILE_TYPE
@export var muzzle: Node3D


func fire():
	var proj_inst: Projectile = PROJECTILES[projectile_type].instantiate()
	proj_inst.global_transform = global_transform
	proj_inst.damage = damage
	get_tree().get_root().add_child(proj_inst)
	proj_inst.add_to_group("instanced")
	proj_inst.set_bodies_to_exclude(bodies_to_exclude)
	super()
