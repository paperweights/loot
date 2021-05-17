extends GridContainer

const PLAYER_INVENTORY: Inventory = preload("res://actors/player/player_inventory.tres")
const SLOT_SCENE = preload("res://ui/slot/slot.tscn")

var _slots = []


func _ready() -> void:
	_update_slot_count()
	_update_slots()
	return


func _update_slot_count() -> void:
	# Destroy current slots.
	for slot in get_children():
		slot.queue_free()
	_slots = []
	# Create new slots.
	var slot_count = PLAYER_INVENTORY.get_size()
	for s in range(slot_count):
		var new_slot = SLOT_SCENE.instance()
		_slots.append(new_slot)
		add_child(new_slot)
	return


func _update_slots() -> void:
	var items = PLAYER_INVENTORY.get_items()
	for i in range(items.size()):
		var item = items[i]
		_slots[i].update_item(items[i])
	return
