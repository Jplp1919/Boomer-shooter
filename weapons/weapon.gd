class_name Weapon

extends Node3D

@export var muzzle_flash : GPUParticles3D
@export var  animation_player : AnimationPlayer
@onready var attack_emmiter: AttackEmitter = $AttackEmitter
@onready var fire_point: Node3D = %FirePoint

@export var automatic = false
@export var damage = 30
@export var ammo = 0
@export var max_ammo = 6
@export var silent_weapon = false

@export var ejection_port: Marker3D
@export var casing_scene: PackedScene

@export var attack_rate = 0.8
var last_attack_time = -9999.9

@export var animation_controlled_attack = false


#ammo pool code
enum AmmoType {
	NONE = -1, # For weapons that don't use ammo
	_9X19, #Pistol
	_8GA, #TrenchBroom, Super Shotgun
	_792X57, #Machinegun
	ROCKET, #Rocket Launcher for debugging projectiles and explosions only
	_45_70 #Cowboy repeater
}
@export var ammo_type: AmmoType = AmmoType.NONE

#ammo pool code
signal fired
signal out_of_ammo
signal ammo_updated(ammo_amnt: int, max_ammo: int)


func _ready() :
	attack_emmiter.set_damage(damage)

func set_bodies_to_exclude (bodies:Array):
	attack_emmiter.set_bodies_to_exclude(bodies)

func attack(input_just_pressed: bool, input_held: bool):
	if !automatic and !input_just_pressed:
		return
	if automatic and !input_held:
		return
	
	if AmmoManager.get_ammo(ammo_type) == 0:
		if input_just_pressed:
			out_of_ammo.emit()
			if has_node("OutOfAmmoSound"):
				$"OutOfAmmoSound".play()
		return
	
	var cur_time = Time.get_ticks_msec() / 1000.0
	if cur_time - last_attack_time < attack_rate:
		return
	
	if ammo_type != AmmoType.NONE:
		AmmoManager.use_ammo(ammo_type, 1)
	
	if !animation_controlled_attack:
		actually_attack()
	last_attack_time = cur_time
	animation_player.stop()
	animation_player.play("attack")
	
	fired.emit()
	if muzzle_flash != null:
		muzzle_flash.emitting = true

func actually_attack():
	attack_emmiter.global_transform = fire_point.global_transform
	attack_emmiter.fire()

func set_active (a:bool):
	visible = a
	if !a:
		animation_player.play("RESET")
	else:
		ammo_updated.emit(AmmoManager.get_ammo(ammo_type), AmmoManager.get_max_ammo(ammo_type))

func is_idle ()->bool:
	return !animation_player.is_playing()
	

func eject_casing():
	var casing = casing_scene.instantiate()
	get_parent().add_child(casing)
	casing.global_transform.origin = ejection_port.global_transform.origin
