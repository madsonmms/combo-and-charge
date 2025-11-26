class_name AttackComponent
extends Node

#signal Next_Combo
signal Combo_Finished

@export var combo_timer : Timer
@export var charge_timer : Timer
@export var hold_timer: Timer
@export var progress_bar : ProgressBar
@export var has_combo : bool
@export var circular_combo: bool
@export var combo_steps : int # Se circular_combo = true, esse valor será = 2
@export var has_charge: bool

var current_combo_step : int = 0
var attacking : bool = false
var is_holding: bool = false
var is_charging : bool = false
var charge_ready : bool = false

func _ready() -> void:
	if has_charge:
		hold_timer.timeout.connect(_on_hold_timeout)
	if has_combo:
		combo_timer.timeout.connect(_on_combo_timeout)

func _process(_delta: float) -> void:
	pass

# Chamado sempre que o ataque é realizado
func attack_handler() -> void:
	if has_charge:
		if !is_holding and hold_timer.is_stopped():
			is_holding = true
			hold_timer.start()
		else:
			charge_attack()
	else:
		normal_attack()

#func release_attack() -> void:
	#if has_charge:
		#charge_attack()
	#else:
		#normal_attack()
	

func charge_attack() -> void:
	
	var hold_time = hold_timer.wait_time
	var time_elapsed = hold_timer.wait_time - hold_timer.time_left
		
	if is_holding:
		if time_elapsed > 0 and time_elapsed < 1:
			is_holding = false
			normal_attack()
		elif time_elapsed == hold_time:
			start_charge_attack()
		else:
			cancel_charge_attack()
			pass

func normal_attack() -> void:
	if current_combo_step == 0:
		start_attack()
	elif current_combo_step != 0 and has_combo:
		try_next_combo()

func start_charge_attack() -> void:
	hold_timer.stop()
	is_holding = false
	charge_ready = false

func cancel_charge_attack() -> void:
	hold_timer.stop()
	is_holding = false
	charge_ready = false

#Inicializa o ataque e o timer
func start_attack() -> void:
	attacking = true
	
	if has_charge:
		hold_timer.stop()
		is_holding = false
		charge_ready = false
	
	if has_combo:
		current_combo_step += 1
		combo_timer.start()

func try_next_combo() -> bool:
	if has_charge:
		hold_timer.stop()
	
	#Checa se está atacando e se ainda tem timer
	if attacking and not combo_timer.is_stopped(): 
		
		if circular_combo:
			_circular_combo()
		else:
			if current_combo_step != combo_steps:
				current_combo_step += 1
			else:
				current_combo_step = 1
		
		#Controla os steps do combo
		#if current_combo_step == 1: 
			#current_combo_step += 1
		#else:
			#current_combo_step -= 1
			
		#controla o timer
		combo_timer.start()

		return true
	return false

func _circular_combo() -> void:
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
