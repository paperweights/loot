extends "res://actors/entity/entity.gd"

var _keys_held = [
	["ui_left", false],
	["ui_right", false],
	["ui_up", false],
	["ui_down", false],
]


func _unhandled_input(event):
	for k in range(len(_keys_held)):
		if event.is_action_pressed(_keys_held[k][0]):
			_keys_held[k][1] = true
			return
		if event.is_action_released(_keys_held[k][0]):
			_keys_held[k][1] = false
			return
	return


func _physics_process(_delta: float):
	# Work out input.
	_input = Vector2(
		float(_keys_held[1][1]) - float(_keys_held[0][1]),
		float(_keys_held[3][1]) - float(_keys_held[2][1])
	)
	._physics_process(_delta)
