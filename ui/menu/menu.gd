extends PanelContainer


func _input(event):
	if event is InputEventKey and event.scancode == KEY_ESCAPE and event.pressed:
		visible = !visible
