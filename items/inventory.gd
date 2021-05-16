class_name Inventory
extends Resource

signal items_changed(indexes)

export(Array, Resource) var _items


func _set_item(item_index: int, item: Resource) -> Resource:
	var old_item = _items[item_index]
	_items[item_index] = item
	emit_signal("items_changed", [item_index])
	return old_item


func _swap_items(from_index: int, to_index: int) -> void:
	# Get the items at the target indices
	var from_item = _items[from_index]
	var to_item = _items[to_index]
	# Swap the items.
	_items[from_index] = to_item
	_items[to_index] = from_item
	emit_signal("items_changed", [from_index, to_index])
	return


func _remove_item(item_index: int) -> Resource:
	return _set_item(item_index, null)
