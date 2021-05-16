extends CenterContainer

const RARITY_COLORS = [
	Color(0.25, 1, 0, 0), # Common
	Color(0.5, 0.25, 0, 0), # Uncommon
	Color(0.5, 0.75, 0, 0), # Rare
	Color(0.25, 0, 0, 0), # Legendary
	Color(0.75, 0, 0, 0), # Relic
	Color(0.75, 1, 0, 0), # Cursed
]

onready var _frame = $Frame
onready var _icon = $Icon


func _ready() -> void:
	_frame.material.set_shader_param("subtract_color", RARITY_COLORS[5])
	return


func update_item(item: Resource) -> void:
	return
