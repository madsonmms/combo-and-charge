extends Node2D

@onready var atkComponent : AttackComponent = $AttackComponent
@onready var label : Label = $Label
@onready var label2 : Label = $Label2

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		atkComponent.Combo_Finished.connect(_on_attack_finished, CONNECT_ONE_SHOT)
		atkComponent.combo_handler()

func _process(delta: float) -> void:
	
	if atkComponent.attacking == true:
		label2.text = "true"
	
	match atkComponent.current_combo_step:
		1:
			label.text = "Combo 1"
		2: 
			label.text = "Combo 2"
		_:
			label.text = "Idle"

func _on_attack_finished():
	label2.text = "false"
