class_name ComboComponent
extends Node

signal Combo_Started
signal Combo_Step
signal Combo_Finished

@export var component_active : bool
@export var is_circular: bool
@export var combo_steps : int # Se combo_circular = true, esse valor será = 2
@export_range(0, 100, 0.1) var combo_cooldown_time : float
#@export var combo_cooldown : Timer

var combo_cooldown : Timer
var current_step : int = 0
var is_active : bool = false

func _ready() -> void:
	
	combo_cooldown = Timer.new()
	combo_cooldown.wait_time = combo_cooldown_time
	combo_cooldown.one_shot = true
	combo_cooldown.timeout.connect(_on_combo_timeout)
	
	add_child(combo_cooldown)

func start_combo() -> void:
	current_step = 1
	is_active = true
	
	if combo_cooldown:
		combo_cooldown.start()
	
	print_debug("Combo started: ", current_step)
	
	Combo_Started.emit()
	Combo_Step.emit(current_step)

func _try_next_combo() -> bool:

	if not is_active or (combo_cooldown and combo_cooldown.time_left <= 0):
		return false
		
	if is_circular:
		current_step = (current_step % combo_steps) + 1
	
	if current_step >= combo_steps:
		reset_combo()
		return false	
		
	if current_step != combo_steps:
		current_step += 1
	
	
	
	if combo_cooldown:
		combo_cooldown.start()
	
	print_debug("Combo continues: ",current_step)
	
	Combo_Step.emit(current_step)
	return true

func reset_combo() -> void:
	current_step = 0
	is_active = false
	
	if combo_cooldown:
		combo_cooldown.stop()
	
	Combo_Finished.emit()

func _on_combo_timeout() -> void:
	reset_combo()


#-- GETTERS :: START -- #

func get_current_step() -> int:
	return current_step
	
func is_last_step() -> bool:
	return current_step == combo_steps and not is_circular
	
func is_combo_active() -> bool:
	return is_active

#-- GETTERS :: END -- #
