extends AttackEmitter
@export var cur_weapon_muzzle : Node3D
@export var only_hit_enviroment = false
@export var is_melee = false
@onready var ray_cast_3d: RayCast3D = $RayCast3D
var bullet_hit_effect = preload("res://effects/bullet_hit_effect.tscn")

@onready var player = get_tree().get_first_node_in_group("player")

#func _ready() -> void:
	#if is_melee:
		#bullet_hit_effect = preload("res://effects/sword_hit_effect.tscn")

func set_bodies_to_exclude (bodies:Array):
	super(bodies)
	for body in bodies:
		ray_cast_3d.add_exception(body)
 
func fire():
	ray_cast_3d.enabled = true
	ray_cast_3d.force_raycast_update()
	var hit_position = ray_cast_3d.global_transform * ray_cast_3d.target_position
	if ray_cast_3d.is_colliding():
		hit_position = ray_cast_3d.get_collision_point()
		var can_hurt = ray_cast_3d.get_collider().has_method("hurt")
		if can_hurt and only_hit_enviroment:
			pass
		elif can_hurt:
			var damage_data = DamageData.new()
			damage_data.amount = damage
			damage_data.hit_pos = hit_position
			ray_cast_3d.get_collider().hurt(damage_data)
		else:
			var hit_effect_inst : Node3D = bullet_hit_effect.instantiate()
			get_tree().get_root().add_child(hit_effect_inst)
			var hit_pos : Vector3 = hit_position
			var hit_normal : Vector3 = ray_cast_3d.get_collision_normal()
			var look_at_pos : Vector3 = hit_pos + hit_normal
			hit_effect_inst.global_position = hit_pos
			if hit_normal.is_equal_approx(Vector3.UP) or hit_normal.is_equal_approx(Vector3.DOWN):
				hit_effect_inst.look_at(look_at_pos, Vector3.RIGHT)
			else:
				hit_effect_inst.look_at(look_at_pos)
			hit_effect_inst.add_to_group("instanced")
	if cur_weapon_muzzle:
		create_bullet_trail(hit_position, cur_weapon_muzzle)
	ray_cast_3d.enabled = false
	super()

func create_bullet_trail(target_pos : Vector3, muzzle : Node3D = null):
	if muzzle == null:
		return
	var bullet_dir = (target_pos - muzzle.global_position).normalized()
	var start_pos = muzzle.global_position + bullet_dir*0.25
	if (target_pos - start_pos).length() > 3.0:
		var bullet_tracer = preload("res://effects/bullet_effects/bullet_tracer.tscn").instantiate()
		player.add_sibling(bullet_tracer)
		bullet_tracer.global_position = start_pos
		bullet_tracer.target_pos = target_pos
		bullet_tracer.look_at(target_pos)
