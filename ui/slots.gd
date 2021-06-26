extends GridContainer

export(Resource) var _equipment;

onready var _bag = $Bag
onready var _head = $Head
onready var _amulet = $Amulet
onready var _left = $Left
onready var _chest = $Chest
onready var _right = $Right
onready var _pouch = $Pouch
onready var _boots = $Boots
onready var _ring = $Ring

func _ready():
	_bag.update_item(_equipment.bag)
	_head.update_item(_equipment.head)
	_amulet.update_item(_equipment.amulet)
	_left.update_item(_equipment.left)
	_chest.update_item(_equipment.chest)
	_right.update_item(_equipment.right)
	_pouch.update_item(_equipment.pouch)
	_boots.update_item(_equipment.boots)
	_ring.update_item(_equipment.ring)
