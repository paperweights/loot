extends ColorRect


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_focus_next"):
		return
	visible = not visible
	return
