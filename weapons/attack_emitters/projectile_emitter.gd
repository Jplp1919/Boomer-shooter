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
@export var aim_cast : RayCast3D

func set_bodies_to_exclude (bodies:Array):
	super(bodies)
	for body in bodies:
		aim_cast.add_exception(body)


func fire():
	var proj_inst: Projectile = PROJECTILES[projectile_type].instantiate()
	proj_inst.global_transform = muzzle.global_transform
	proj_inst.damage = damage
	aim_cast.enabled = true
	aim_cast.force_raycast_update()
	get_tree().get_root().add_child(proj_inst)
	if aim_cast.is_colliding():
		proj_inst.look_at(aim_cast.get_collision_point(), Vector3.UP)
	aim_cast.enabled = false
	proj_inst.add_to_group("instanced")
	proj_inst.set_bodies_to_exclude(bodies_to_exclude)
	super()


#func fire():
	#var proj_inst: Projectile = PROJECTILES[projectile_type].instantiate()
	#proj_inst.global_transform = global_transform
	#proj_inst.damage = damage
	#get_tree().get_root().add_child(proj_inst)
	#proj_inst.add_to_group("instanced")
	#proj_inst.set_bodies_to_exclude(bodies_to_exclude)
	#super()
