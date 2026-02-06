class_name AttackComponent
extends Node

signal Attack_Started
signal Attack_Completed

@export_range(0, 10, 0.1) var attack_duration : float
@export_range(0, 100, 0.1) var attack_cooldown_time: float

var attack_cooldown : Timer


func _ready() -> void:
	
	attack_cooldown = Timer.new()
	attack_cooldown.one_shot = true
	attack_cooldown.wait_time = attack_cooldown_time
	
	add_child(attack_cooldown)

func start_attack() -> void:
	Attack_Started.emit()
	
	if attack_cooldown:
		attack_cooldown.start()
		
	get_tree().create_timer(attack_duration).timeout.connect(
		func(): Attack_Completed.emit(),
		CONNECT_ONE_SHOT
	)

func can_attack() -> bool:
	return not is_on_cooldown()

func is_on_cooldown() -> bool:
	if attack_cooldown:
		return attack_cooldown.time_left > 0
	return false
