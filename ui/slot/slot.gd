extends CenterContainer



onready var _frame = $Frame
onready var _icon = $Icon


func update_item(item: Item) -> void:
	if item is Item:
		_icon.texture = item.get_texture()
		_frame.material.set_shader_param("subtract_color", item.get_rarity_color())
	else:
		_icon.texture = null
	return
