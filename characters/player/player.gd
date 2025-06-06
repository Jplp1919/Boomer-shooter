extends CharacterBody3D

@onready var camera_3d: Camera3D = $"Camera Holder/Camera3D"
@onready var character_mover: Node3D = $CharacterMover
@onready var weapon_manager: Node3D = %WeaponManager
@onready var health_manager: Node3D = $HealthManager
@onready var death_screen: Control = $"PlayerUi/Death Screen"



@export var mouse_sensitivity_h = 0.15
@export var mouse_sensitivity_v = 0.15

var mouse_captured = true
var dead = false

const HOTKEYS ={
	KEY_1: 0,
	KEY_2: 1,
	KEY_3: 2,
	KEY_4: 3,
	KEY_5: 4,
	KEY_6: 5,
	KEY_7: 6,
	KEY_8: 7,
	KEY_9: 8,
	KEY_0: 9
}

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	health_manager.died.connect(kill)

func _input(event):
	if dead:
		return
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity_h
		camera_3d.rotation_degrees.x -= event.relative.y * mouse_sensitivity_v
		camera_3d.rotation_degrees.x = clamp(camera_3d.rotation_degrees.x, -80, 80)
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			weapon_manager.switch_to_previous_weapon()
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			weapon_manager.switch_to_next_weapon()
	if event is InputEventKey and event.pressed and event.keycode in HOTKEYS:
		weapon_manager.switch_to_weapon_slot(HOTKEYS[event.keycode])

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("restart"):
		get_tree().call_group("instanced", "queue_free")
		get_tree().reload_current_scene()
		AmmoManager.reset_ammo()
		
	if Input.is_action_just_pressed("fullscreen"):
		var fs = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		if fs:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if dead:
		return
	var input_dir = Input.get_vector("move_left", "move_right", "move_foward", "move_backward")
	var move_dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized())
	
	character_mover.set_move_dir(move_dir)
	if Input.is_action_just_pressed("jump"):
		character_mover.jump()
	weapon_manager.attack(Input.is_action_just_pressed("attack"), Input.is_action_pressed("attack"))
	
	weapon_manager.alt_attack(Input.is_action_just_pressed("alt_attack"), Input.is_action_pressed("alt_attack"))
	
	if Input.is_action_just_pressed("mouse_toggle"):
		if mouse_captured:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			mouse_captured = false
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			mouse_captured = true

func kill():
	dead = true
	character_mover.set_move_dir(Vector3.ZERO)
	death_screen.show_death_screen()

func hurt(damege_data : DamageData):
	health_manager.hurt(damege_data)


func get_player_velocity():
	return character_mover.character_body.velocity
