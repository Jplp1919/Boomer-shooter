extends Projectile

@export var gravity = 2.0
var velocity : Vector3 = Vector3.ZERO
var hit_effect = preload("res://effects/burn_hit_effect.tscn") #switch to plasma hit effect
#var target_position : Vector3
#var muzzle : Node3D
#var start_pos : Vector3


func process_movement(delta):
	last_pos = global_position
	global_position += -global_transform.basis.z * speed * delta
	velocity.y -= gravity * delta
	global_position += velocity * delta

func on_hit(hit_collider: Node3D, hit_pos: Vector3, hit_normal: Vector3):
	super(hit_collider, hit_pos, hit_normal)
	var hit_effect_inst : Node3D = hit_effect.instantiate()
	var look_at_pos : Vector3 = hit_pos + hit_normal
	var can_hurt = collision_ray_cast.get_collider().has_method("hurt")
	if can_hurt:
		pass
	else:
		get_tree().get_root().add_child(hit_effect_inst)
		hit_effect_inst.global_position = hit_pos
		if hit_normal.is_equal_approx(Vector3.UP) or hit_normal.is_equal_approx(Vector3.DOWN):
			hit_effect_inst.look_at(look_at_pos, Vector3.RIGHT)
		else:
			hit_effect_inst.look_at(look_at_pos)
		hit_effect_inst.add_to_group("instanced")
