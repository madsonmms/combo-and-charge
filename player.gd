extends Node2D

@onready var atkComponent : AttackComponent = $AttackComponent
@onready var label : Label = $Label
@onready var label2 : Label = $Label2

func _ready() -> void:
	atkComponent.Combo_Finished.connect(_on_attack_finished)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		atkComponent.attack_handler()
	
	if event.is_action_released("ui_down"):
		atkComponent.attack_handler()

func _process(_delta: float) -> void:
	
	if atkComponent.attacking == true:
		label2.text = "true"
		
		if atkComponent.current_combo_step != 0:
			label.text = "Combo " + str(atkComponent.current_combo_step)
		else:
			label.text = "Idle"
		
	elif atkComponent.is_holding:
		if atkComponent.charge_ready:
			label.text = "Charge PRONTO!"
		else:
			label.text = "Charging..."
	else:
		label.text = "Idle"
		label2.text = "false"

func _on_attack_finished():
	label2.text = "false"
