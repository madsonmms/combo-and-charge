class_name AttackComponent
extends Node

#signal Next_Combo
signal Combo_Finished

@export_group("Combo System", "combo_")
@export var combo : bool
@export var combo_circular: bool
@export var combo_steps : int # Se combo_circular = true, esse valor será = 2
@export var combo_timer : Timer

@export_group("Charge System", "charge_")
@export var charge: bool
@export var charge_timer: Timer

var current_combo_step : int = 0
var attacking : bool = false
var is_holding: bool = false
var is_charging : bool = false
var charge_ready : bool = false

func _ready() -> void:
	_setup_timers()

func _setup_timers() -> void:
	if charge:
		charge_timer.timeout.connect(_on_hold_timeout)
	if combo:
		combo_timer.timeout.connect(_on_combo_timeout)

#== ENTRADA ==#
func attack_handler() -> void:
	if charge:
		_try_start_charge()
	else:
		_perform_normal_attack()

func release_handler() -> void:
	if is_holding and !charge_ready:
		_cancel_charge_attack()
	if is_holding and charge_ready:
		_charge_reseter()

func _try_start_charge() -> void:
	charge_timer.start()
	is_holding = true
	

func _perform_normal_attack() -> void:
	if current_combo_step == 0:
		start_attack()
	elif combo and current_combo_step != 0:
		try_next_combo()
		
#Inicializa o ataque e o timer
func start_attack() -> void:
	attacking = true
	
	if charge:
		charge_timer.stop()
		is_holding = false
		charge_ready = false
	
	if combo:
		current_combo_step = 1
		combo_timer.start()

func try_next_combo() -> bool:
	print_debug("antes do combo:", current_combo_step)
	if charge:
		charge_timer.stop()
	
	#Checa se está atacando e se ainda tem timer
	if attacking and combo_timer.time_left > 0: 
		
		if combo_circular:
			_combo_circular()
		else:
			if current_combo_step < combo_steps:
				current_combo_step += 1
			else:
				current_combo_step = 1
		
		combo_timer.start()
		print_debug("depois do combo:", current_combo_step)
		return true
	return false
	

func _charge_reseter() -> void:
	charge_timer.stop()
	is_holding = false
	charge_ready = false

func _cancel_charge_attack() -> void:
	
	var time_elapsed = charge_timer.wait_time - charge_timer.time_left
	
	if time_elapsed > 0 and time_elapsed < 1:
		_charge_reseter()
		_perform_normal_attack()
	else:
		_charge_reseter()
	


func _combo_circular() -> void:
	combo_steps = 2
	
	if current_combo_step == combo_steps:
		current_combo_step -= 1
	else:
		current_combo_step += 1

# Executado para resetar o combo
func _on_combo_timeout() -> void:
	attacking = false
	current_combo_step = 0
	Combo_Finished.emit()

# Quando o charge está pronto para o release
func _on_hold_timeout():
	if is_holding:
		charge_ready = true
