extends Node3D

@onready var fire_area: Area3D = $FireArea

var burning = false

func burn():
	for body in fire_area.get_overlapping_bodies():
		if body.has_method("hurt"):
			burning = true
			var damage_data = DamageData.new()
			damage_data.amount = 5
			damage_data.hit_pos = body.global_position + Vector3.UP
			body.hurt(damage_data)
			await get_tree().create_timer(1).timeout
			burning = false

func _process(delta):
	if !burning:
		burn()
