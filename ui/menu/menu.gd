extends PanelContainer

signal toggled(new_state)

export (bool) var _can_toggle = true


func _input(event):
	if event is InputEventKey and event.scancode == KEY_ESCAPE \
	and event.pressed:
		set_state(!visible)


func set_state(enabled: bool):
	if !_can_toggle:
		return
	visible = enabled
	emit_signal("toggled", enabled)


# Disable menu when hud turns on
func _on_Menu_toggled(new_state):
	if visible and new_state:
		set_state(false)
