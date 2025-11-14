class_name AttackComponent
extends Node

#signal Next_Combo
signal Combo_Finished

@export var combo_timer : Timer
@export var charge_timer : Timer
@export var hold_timer: Timer
@export var hold_threshold : float = 3

var current_combo_step : int = 0
var attacking : bool = false
var is_holding: bool = false
var is_charging : bool = false
var charge_ready : bool = false

func _ready() -> void:
	hold_timer.timeout.connect(_on_hold_timeout)
	combo_timer.timeout.connect(_on_combo_timeout)

func _process(_delta: float) -> void:
	pass

func combo_handler() -> void:
	#if current_combo_step == 0:
	is_holding = true
	hold_timer.start(hold_threshold)
	#elif hold_timer.is_stopped():
		#start_charge()
		
func release_attack() -> void:
	if is_holding:
		if hold_timer.time_left > 0:
			is_holding = false
			if current_combo_step == 0:
				start_attack()
			else:
				try_next_combo()
		else:
			start_charge_attack()
			
			
func start_charge_attack() -> void:
	hold_timer.stop()
	print_debug("Charge release!")


#Inicializa o ataque e o timer
func start_attack() -> void:
	hold_timer.stop()
	is_holding = false
	charge_ready = false
	attacking = true
	current_combo_step += 1
	combo_timer.start()

func try_next_combo() -> bool:
	
	#Checa se está atacando e se ainda tem timer
	if attacking and not combo_timer.is_stopped(): 
		
		#Controla os steps do combo
		if current_combo_step == 1: 
			current_combo_step += 1
		else:
			current_combo_step -= 1
			
		#controla o timer
		combo_timer.start()

		return true
	return false

func _on_combo_timeout() -> void:
	attacking = false
	current_combo_step = 0
	Combo_Finished.emit()

	
func _on_hold_timeout():
	if is_holding:
		charge_ready = true
		print_debug("Charge ready!")
