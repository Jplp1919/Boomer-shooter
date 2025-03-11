extends Node3D

@export var explosion_force = 15.0
@export var max_explosion_dist = 3.5

func apply_explosion_push(explosion_origin: Vector3):
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	var shape = SphereShape3D.new()
	shape.radius = max_explosion_dist
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

func get_explosion_direction(body: Node3D, explosion_origin: Vector3) -> Vector3:
	var direction = (body.global_transform.origin - explosion_origin).normalized()
	direction.y += 0.5 
	if direction.length() < 0.1:
		direction = Vector3.UP 
	return direction.normalized()

func apply_force_to_body(body: RigidBody3D, explosion_origin: Vector3):
	var direction = get_explosion_direction(body, explosion_origin)
	var distance = max(0.1, (body.global_transform.origin - explosion_origin).length())
	var force = direction * explosion_force / distance
	body.apply_central_impulse(force)
	body.linear_velocity += force * 1.5

func apply_force_to_character(body: CharacterBody3D, explosion_origin: Vector3):
	var direction = get_explosion_direction(body, explosion_origin)
	var distance = max(0.1, (body.global_transform.origin - explosion_origin).length())
	var force = direction * (explosion_force / 3.0) / distance
	body.velocity += force
	body.move_and_collide(force * 0.1)
