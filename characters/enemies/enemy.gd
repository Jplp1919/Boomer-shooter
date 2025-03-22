class_name Enemy
extends CharacterBody3D


@onready var health_manager: Node3D = $HealthManager 

@export var  animation_player : AnimationPlayer

@export var attack_range = 2.0
@export var damage = 15

@export var attack_speed_modifier = 1.0

enum STATES {IDLE, ATTACK, DEAD}
var cur_state = STATES.IDLE

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	var hitboxes = find_children("*", "HitBox")
	for hitbox in hitboxes:
		hitbox.on_hurt.connect(health_manager.hurt)
	health_manager.died.connect(set_state.bind(STATES.DEAD))
	health_manager.gibbed.connect(queue_free)
	
	hitboxes.append(self)
	#bullet_emitter.set_bodies_to_exclude(hitboxes)
	#bullet_emitter.set_damage(damage)
	set_state(STATES.IDLE)

func hurt(damege_data : DamageData):
	health_manager.hurt(damege_data)

func kill():
	health_manager.kill()

func set_state(state: STATES):
	if cur_state == STATES.DEAD:
		return
	cur_state = state
	match cur_state:
		STATES.ATTACK:
			print("attack state set")
		STATES.IDLE:
			animation_player.play("idle")
		STATES.DEAD:
			animation_player.play("die", 0.2)
			collision_layer = 0
			collision_mask = 1
			#ai_character_mover.stop_moving()
