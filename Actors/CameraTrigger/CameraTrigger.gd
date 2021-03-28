extends Node2D

export (Vector2) var _min_room = Vector2()
export (Vector2) var _max_room = Vector2()

func _on_area_entered(body):
	if !body.is_in_group('Player'):
		return
	get_tree().call_group('Camera', 'update_room_size', _min_room, _max_room)
	return
