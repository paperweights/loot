extends TextureRect


func _ready() -> void:
	Input.set_mouse_mode(1)
	return


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		set_global_position(event.position)
	return
