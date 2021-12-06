extends TabContainer

signal toggled(new_state)

const TOGGLE_ACTION = "menu_toggle"
const MENU_ACTIONS = ["menu_equip", "menu_bag", "menu_map"]
const MENU_COUNT = len(MENU_ACTIONS)


func _unhandled_input(event: InputEvent):
	# Toggle
	if event.is_action_pressed(TOGGLE_ACTION):
		_switch_tab(current_tab)
		return
	# Tabs.
	for t in range(MENU_COUNT):
		if event.is_action_pressed(MENU_ACTIONS[t]):
			_switch_tab(t)
			return
	return


func _switch_tab(new_tab: int):
	# Switch to new tab if current one is not the same.
	if current_tab != new_tab:
		current_tab = new_tab
		visible = true
	# Toggle visibility otherwise.
	else:
		visible = !visible
	emit_signal("toggled", visible)
	return


# Disable hud when menu turns on
func _on_MainMenu_toggled(new_state):
	if visible and new_state:
		_switch_tab(current_tab)
