class_name Item
extends Resource

enum Rarity {Common, Uncommon, Rare, Legendary, Relic, Cursed}

const RARITY_COLORS = [
	Color(0.25, 1, 0, 0), # Common
	Color(0.5, 0.25, 0, 0), # Uncommon
	Color(0.5, 0.75, 0, 0), # Rare
	Color(0.25, 0, 0, 0), # Legendary
	Color(0.75, 0, 0, 0), # Relic
	Color(0.75, 1, 0, 0), # Cursed
]

export(String) var _name = "John doe"
export(int) var _value = 20
export(Rarity) var _rarity
export(StreamTexture) var _sprite


func get_texture() -> StreamTexture:
	return _sprite


func get_rarity_color() -> Color:
	return RARITY_COLORS[_rarity]
