class_name Enemy
extends CharacterBody3D

@onready var health_manager: Node3D = $HealthManager 

func _ready():
	var hitboxes = find_children("*", "HitBox")
	for hitbox in hitboxes:
		hitbox.on_hurt.connect(health_manager.hurt)
	health_manager.gibbed.connect(queue_free)
	
	hitboxes.append(self)

func hurt(damege_data : DamageData):
	health_manager.hurt(damege_data)

func kill():
	health_manager.kill()
