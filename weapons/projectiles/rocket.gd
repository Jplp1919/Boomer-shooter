extends Projectile

@onready var area_damage_emitter: Node3D = $AreaDamageEmitter

@onready var force_manager: Node3D = $ForceManager


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
	
	#await get_tree().create_timer(0.15).timeout
	#$ExplosionSmokeParticles.restart()
