class_name RoomPalette
extends Resource

export(Array, PackedScene) var _rooms


func get_length() -> int:
	return len(_rooms)


func get_room(index: int) -> PackedScene:
	return _rooms[index]
