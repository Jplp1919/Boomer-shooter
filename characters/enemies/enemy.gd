class_name Enemy
extends CharacterBody3D

@onready var ai_character_mover: Node3D = $AICharacterMover
@onready var health_manager: Node3D = $HealthManager 
@export var  animation_player : AnimationPlayer
@onready var vision_manager: VisionManager = $VisionManager
@onready var attack_emitter: AttackEmitter = $AttackEmitter
@onready var nearby_enemies_alert_area: Area3D = $NearbyEnemiesAlertArea



@export var attack_range = 2.0
@export var damage = 15

var disarmed := false
var beheaded := false

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
	attack_emitter.set_bodies_to_exclude(hitboxes)
	attack_emitter.set_damage(damage)
	set_state(STATES.IDLE) 

func hurt(damege_data : DamageData):
	health_manager.hurt(damege_data)

func kill():
	health_manager.kill()

func alert():
	if not cur_state in [STATES.ATTACK, STATES.DEAD]:
		#$AlertSound.play()
		set_state(STATES.ATTACK)
		alert_nearby_enemies()

func alert_nearby_enemies():
	for b in nearby_enemies_alert_area.get_overlapping_bodies():
		if b is Enemy:
			b.alert()

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
			if beheaded:
				animation_player.play("dismembered_head", 0.2)
			else:
				animation_player.play("die", 0.2)
			collision_layer = 0
			collision_mask = 1
			ai_character_mover.stop_moving()

func _process(delta: float) -> void:
	match cur_state:
		STATES.IDLE:
			process_idle_state(delta)
		STATES.ATTACK:
			process_attack_state(delta)


func process_idle_state(delta: float) -> void:
	if vision_manager.can_see_target(player):
		alert()

func process_attack_state(delta: float) -> void:
	var attacking = animation_player.current_animation == "attack"
	var vec_to_player = player.global_position -global_position
	
	if vec_to_player.length() <= attack_range:
		ai_character_mover.stop_moving()
		if !attacking and vision_manager.is_facing_target(player):
			start_attack()
		elif !attacking:
			ai_character_mover.set_facing_dir(vec_to_player)
	elif !attacking:
		ai_character_mover.set_facing_dir(ai_character_mover.move_dir)
		ai_character_mover.move_to_point(player.global_position)
		animation_player.play("walk", -1, 2.0)

func start_attack():
	#$AttackSound.play()
	if disarmed:
		damage = 2
		attack_emitter.set_damage(damage)
		animation_player.play("kick", -1, attack_speed_modifier)
	else:
		animation_player.play("attack", -1, attack_speed_modifier)

func do_attack(): #called from animation
	attack_emitter.fire()
