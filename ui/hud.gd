extends TabContainer

const TOGGLE_ACTION = "menu_toggle"
const MENU_ACTIONS = ["menu_equip", "menu_bag", "menu_map"]

func _unhandled_input(event: InputEvent) -> void:
	# Toggle
	if event.is_action_pressed(TOGGLE_ACTION):
		_switch_tab(current_tab)
		return
	# Tabs.
	for t in range(len(MENU_ACTIONS)):
		if event.is_action_pressed(MENU_ACTIONS[t]):
			_switch_tab(t)
			return
	return


func _switch_tab(new_tab: int) -> void:
	# Switch to new tab if current one is not the same.
	if current_tab != new_tab:
		current_tab = new_tab
		visible = true
	# Toggle visibility otherwise.
	else:
		visible = not visible
	return
