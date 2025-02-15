extends Node3D
@onready var cur_health = max_health

@export var max_health = 100
@export var gib_when_damage_taken = 20
var has_gibbed = false
@export var verbose = false
@export var bleeds = true
@export var blood_splatter_count = 3
@export var blood_splatter_range = 2.0
@export var blood_splatter_variance = 0.5
@export var min_gib_spawn_amnt = 3
@export var max_gib_spawn_amnt = 8

signal died
signal healed
signal damaged
signal gibbed
signal health_changed(cur_health, max_health)

func _ready():
	health_changed.emit(cur_health, max_health)
	if verbose:
		print("Starting health: %s %s" % [cur_health, max_health])

var damage_taken_this_frame = 0
var last_frame_damaged = -1

func hurt(damage_data : DamageData):
	var cur_frame = Engine.get_process_frames()
	if  last_frame_damaged!= cur_frame:
		damage_taken_this_frame = 0
	last_frame_damaged = cur_frame
	damage_taken_this_frame += damage_data.amount
	var dead = cur_health <= 0
	if dead and damage_taken_this_frame >= gib_when_damage_taken:
		gib()
	if dead:
		return
	cur_health -= damage_data.amount
	dead = cur_health <= 0
	if dead:
		if verbose:
			print("died")
		died.emit()
		if has_node("DieSound"):
			$"DieSound".play()
		if dead and damage_taken_this_frame >= gib_when_damage_taken:
			gib()
	else:
		damaged.emit()
		if has_node("HurtSound"):
			$"HurtSound".play()
	health_changed.emit(cur_health, max_health)
	if verbose:
		print("Damaged for %s, health: %s %s" % [damage_data.amount, cur_health, max_health])

func gib():
	if has_gibbed:
		return
	if verbose:
		print("gibbed")

func heal(amount  : int):
	if cur_health <= 0:
		return
	cur_health = clamp(cur_health + amount, 0, max_health)
	healed.emit()
	health_changed.emit(cur_health, max_health)
	if verbose:
		print("Healed for %s, health: %s %s" % [amount, cur_health, max_health])
		
