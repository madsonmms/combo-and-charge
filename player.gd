extends Node2D

@onready var atkComponent : AttackComponent = $AttackComponent
@onready var status : Label = $Status
@onready var attacking : Label = $Attacking
@onready var holding : Label = $Holding
@onready var charging : Label = $"ChargeReady"
@onready var progress_bar : ProgressBar = $ProgressBar

func _ready() -> void:
	atkComponent.Combo_Finished.connect(_on_attack_finished)
	
	if progress_bar:
		progress_bar.min_value = 0
		progress_bar.max_value = atkComponent.charge_timer.wait_time

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		atkComponent.attack_handler()
	
	if event.is_action_released("ui_down"):
		atkComponent.release_handler()
		

func _process(_delta: float) -> void:
	
	var holding_timer = atkComponent.charge_timer
	
	var hold_time = holding_timer.wait_time
	var hold_left = holding_timer.time_left
	
	if progress_bar and hold_left > 0:
		progress_bar.value = hold_time - hold_left
	elif atkComponent.charge_ready and holding_timer.is_stopped():
		progress_bar.value = 100
	else:
		progress_bar.value = 0
	
	if atkComponent.is_holding == true:
		holding.text = "true"
	else:
		holding.text = "false"
	
	if atkComponent.charge_ready == true:
		charging.text = "true"
	else:
		charging.text = "false"
	
	if atkComponent.attacking == true:
		attacking.text = "true"
		
		if atkComponent.current_combo_step != 0:
			status.text = "Combo " + str(atkComponent.current_combo_step)
		else:
			status.text = "Idle"
		
	elif atkComponent.is_holding:
		if atkComponent.charge_ready:
			status.text = "Charge PRONTO!"
		else:
			status.text = "Charging..."
	elif atkComponent.charge_attack:
		status.text = "CHARGE ATTACK!"
	else:
		status.text = "Idle"
		attacking.text = "false"

func _on_attack_finished():
	attacking.text = "false"
