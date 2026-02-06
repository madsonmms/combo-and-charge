class_name AttackModule
extends Node

#signal Next_Combo
signal Combo_Finished

@export var attack_cooldown : Timer

@export_group("Attack Component", "combo_")
@export var attack_component : AttackComponent

@export_group("Combo System", "combo_")
@export var combo_component: ComboComponent
@export var combo : bool
@export var combo_circular: bool
@export var combo_steps : int # Se combo_circular = true, esse valor será = 2
@export var combo_cooldown : Timer

@export_group("Charge System", "charge_")
@export var charge: bool
@export var charge_start_time: float
@export var charge_timer: Timer

var attacking : bool = false
var current_combo_step : int = 0

var is_holding: bool = false
var is_charging : bool = false
var charge_ready : bool = false
var charge_attack: bool = false

func _ready() -> void:
	if combo_component:
		combo_component.Combo_Finished.connect(_on_combo_finished)
	
	if attack_component:
		attack_component.Attack_Completed.connect(_on_attack_finished)


#== ENTRY POINT ==#
func attack_handler() -> void:
	
	if attack_component and attack_component.is_on_cooldown():
		return
	
	_start_attack()
		

func release_handler() -> void:
	#if is_holding and !charge_ready:
		#_cancel_charge_attack()
	#if is_holding and charge_ready:
		#charge_attack = true
		#attack_cooldown.start()
		#_charge_reseter()
	pass

#func _try_start_charge() -> void:
	#charge_timer.start()
	#is_holding = true
	#
#
#func _perform_normal_attack() -> void:
	#if current_combo_step == 0:
		#_start_attack()
		
#Inicializa o ataque e o timer
func _start_attack() -> void:
	attacking = true
	
	if charge:
		charge_timer.stop()
		is_holding = false
		charge_ready = false
	
	if combo_component and combo_component.is_combo_active():
		if combo_component._try_next_combo():
			attack_component.start_attack()
	
	if combo_component and combo_component.current_step == 0:
		combo_component.start_combo()

	attack_component.start_attack()
	


func _charge_reseter() -> void:
	charge_timer.stop()
	is_holding = false
	charge_ready = false

func _cancel_charge_attack() -> void:
	
	var time_elapsed = charge_timer.wait_time - charge_timer.time_left
	
	if time_elapsed > 0 and time_elapsed < charge_start_time:
		_charge_reseter()
		#_perform_normal_attack()
	else:
		_charge_reseter()
	

func _on_attack_reset_timeout() -> void:
	if attack_cooldown.is_stopped():
		attacking = false


func _on_combo_finished() -> void:
	attacking = false
	pass

func _on_attack_finished() -> void:
	if not combo_component or not combo_component.is_combo_active():
		attacking = false
	pass

# Executado para resetar o combo
func _on_combo_timeout() -> void:
	attacking = false
	Combo_Finished.emit()

# Quando o charge está pronto para o release
func _on_hold_timeout():
	if is_holding:
		charge_ready = true
