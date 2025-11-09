extends Node

@export var hold_length: float = 2.0

signal key_held

func _ready():
  key_held.timeout.connect(_hold_timeout)

func _hold_timeout():
  print('held for %s seconds', hold_length)

func _process(deleta: float):
  # Watch for keypress
  if Input.is_action_just_pressed('my_key'):
	key_held = get_tree().create_timer(hold_length)
  
  # Watch for keyrelease
  if Input.is_action_just_released('my_key'):
	key_held.stop()
