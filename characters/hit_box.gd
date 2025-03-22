class_name HitBox
extends Area3D

@export var weak_spot = false
@export var critical_damage_multiplier = 2

enum LimbType {
	Other,
	Right_Arm,
	Left_Arm,
	Head
}

@export var health : int = 50

#new code for dismemberment
@export var Parent : Node3D
#@export var mesh : MeshInstance3D
#@export var bone : BoneAttachment3D
@export var kill_parent_on_death : bool = false
#new code for dismemberment

@export var meshes_to_destroy: Array[MeshInstance3D]
#@export var bones_to_destroy: Array[BoneAttachment3D]
signal on_hurt(damage_data: DamageData)

func hurt(damage_data: DamageData):
	if weak_spot:
		damage_data.amount *= critical_damage_multiplier
	on_hurt.emit(damage_data)
	#new code for dismemberment
	health -= damage_data.amount
	var dead = health <= 0
	if dead:
		#if mesh:
			#mesh.queue_free()
			#queue_free()
		if meshes_to_destroy:
			destroy_linked_meshes_and_bones()
			queue_free()
		#if bone:
			#bone.queue_free()
			
		if kill_parent_on_death:
			if Parent:
				Parent.kill()
	

func destroy_linked_meshes_and_bones():
	for mesh in meshes_to_destroy:
		if mesh:
			mesh.queue_free()
	#for bone in bones_to_destroy:
		#if bone:
			#bone.queue_free()
