class_name AttackComponent
extends Node

#signal Next_Combo
signal Combo_Finished
signal Charge_Attack_Ready
signal Hold_Charge

@export var combo_timer : Timer
@export var charge_timer : Timer
@export var hold_timer: Timer

var current_combo_step : int = 0
var attacking : bool = false
var is_charging : bool = false
var charge_ready : bool = false

func _ready() -> void:
	hold_timer.timeout.connect(_on_holding_button)
	combo_timer.timeout.connect(_on_combo_timeout)

func combo_handler() -> void:
	hold_timer.start()
	
	if current_combo_step == 0:
		start_attack()
	#elif hold_timer.is_stopped():
		#start_charge()
	else:
		try_next_combo()

#Inicializa o ataque e o timer
func start_attack() -> void:
	attacking = true
	current_combo_step += 1
	combo_timer.start()
#
#func start_charge() -> void:
	#is_charging = true
	#charge_timer.start()
	
#func update_charge() -> void:
	#if is_charging:
		#charge_timer.timeout.connect(_charge_ready)
	#else:
		#start_attack()
#
#func _charge_ready():
	#if is_charging:
		#charge_ready = true
		#Charge_Attack_Ready.emit()

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
	
func _on_holding_button() -> void:
	hold_timer.start()
