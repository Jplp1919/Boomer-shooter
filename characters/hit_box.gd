class_name HitBox
extends Area3D

@export var weak_spot = false
@export var critical_damage_multiplier = 2


@export var health : int = 50


#new code for dismemberment
@export var Parent : Node3D
@export var mesh : MeshInstance3D
@export var linked_mesh : MeshInstance3D
@export var bone : BoneAttachment3D
@export var linked_bone : BoneAttachment3D
@export var kill_parent_on_death : bool = false
#new code for dismemberment

signal on_hurt(damage_data: DamageData)

func hurt(damage_data: DamageData):
	if weak_spot:
		damage_data.amount *= critical_damage_multiplier
	on_hurt.emit(damage_data)
	#new code for dismemberment
	health -= damage_data.amount
	var dead = health <= 0
	if dead:
		if mesh:
			mesh.queue_free()
		if linked_mesh:
			linked_mesh.queue_free()
		if bone:
			bone.queue_free()
		if linked_bone:
			linked_bone.queue_free()
		if kill_parent_on_death:
			Parent.kill()
