extends "res://actors/entity/entity.gd"


func _physics_process(_delta: float):
	# work out the input
	_input = Vector2(
		-Input.get_action_strength("ui_left") + Input.get_action_strength("ui_right"),
		-Input.get_action_strength("ui_up") + Input.get_action_strength("ui_down")
	)
	._physics_process(_delta)
