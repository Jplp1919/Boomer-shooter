extends Projectile

@onready var area_damage_emitter: Node3D = $AreaDamageEmitter

@export var explosion_force = 15.0
@export var max_explosion_dist = 3.5

#@export var gravity = 2.0
#var velocity : Vector3 = Vector3.ZERO
#commented code is to apply gravity to projectiles
#func process_movement(delta):
#	last_pos = global_position
#	global_position += -global_transform.basis.z * speed * delta
#	velocity.y -= gravity * delta
#	global_position += velocity * delta

func on_hit(hit_collider: Node3D, hit_pos: Vector3, hit_normal: Vector3):
	super(hit_collider, hit_pos, hit_normal)
	#$ExplosionSound.play()
	#$TrailSmokeParticles.emitting = false
	area_damage_emitter.damage = damage
	area_damage_emitter.fire()
	#var explosion_effect := preload("res://effects/explosions/explosion.tscn").instantiate()
	#add_sibling(explosion_effect)
	#$ExplosionFireBall.restart()
	#$ExplosionSparkParticles.restart()
	
	apply_explosion_push(hit_pos)
	
	#await get_tree().create_timer(0.15).timeout
	#$ExplosionSmokeParticles.restart()


func apply_explosion_push(explosion_origin: Vector3):
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	var shape = SphereShape3D.new()
	shape.radius = 5.0  # Adjust explosion radius
	query.shape = shape
	query.transform.origin = explosion_origin
	query.collide_with_bodies = true

	var results = space_state.intersect_shape(query)

	for result in results:
		var body = result.collider
		if body is RigidBody3D:
			apply_force_to_body(body, explosion_origin)
		elif body is CharacterBody3D:
			apply_force_to_character(body, explosion_origin)

func apply_force_to_body(body: RigidBody3D, explosion_origin: Vector3):
	var direction = (body.global_transform.origin - explosion_origin).normalized()
	var distance = max(0.1, (body.global_transform.origin - explosion_origin).length())
	var force = direction * 25.0 / distance 
	body.apply_central_impulse(force)

func apply_force_to_character(body: CharacterBody3D, explosion_origin: Vector3):
	var direction = (body.global_transform.origin - explosion_origin).normalized()
	var distance = max(0.1, (body.global_transform.origin - explosion_origin).length())
	#var force = direction * 50.0 / distance    to the moon baby
	var force = direction * 3.0 / distance 
	body.velocity += force  
