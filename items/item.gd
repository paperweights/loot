class_name Item
extends Resource

enum Rarity {Common, Uncommon, Rare, Epic, Legendary, Relic}

export(String) var _name = "John doe"
export(int) var _value = 20
export(Rarity) var _rarity
export(StreamTexture) var _sprite
