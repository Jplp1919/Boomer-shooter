extends Control
@onready var weapon_manager: Node3D = %WeaponManager

@onready var health_display: Label = $Health
@onready var ammo_display: Label = $Ammo
@onready var health_manager: Node3D = %HealthManager

func _ready() -> void:
	health_manager.health_changed.connect(updtate_health_display)
	for weapon in weapon_manager.weapons:
		weapon.ammo_updated.connect(updtate_ammo_display)
	updtate_ammo_display(weapon_manager.cur_weapon.ammo, weapon_manager.cur_weapon.max_ammo)


func updtate_ammo_display (ammo_amnt: int, max_ammo: int):
	#if ammo_amnt < 0: 
		#ammo_display.text = "0/0"
	#else:
		#ammo_display.text = "%s/%s" % [ammo_amnt, max_ammo]
	if ammo_amnt < 0: 
		ammo_display.text = "-"
	else:
		ammo_display.text = "%s" % [ammo_amnt]

func updtate_health_display (cur_health: int):
	if  cur_health > 0:
		health_display.text = "%s" % [cur_health]
	else:
		health_display.text = "0"
