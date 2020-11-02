extends Node2D

export (NodePath) var _target_node = ""
export (Vector2) var _room_size = Vector2()

export (Vector2) var _min_room = Vector2()
export (Vector2) var _max_room = Vector2()

onready var _target = get_node(_target_node)

func _ready():
	update_room_size(_min_room, _max_room)
	position = get_target_pos()
	return

func _process(delta: float):
	position = get_target_pos()
	return

func get_target_pos() -> Vector2:
	var t_pos = _target.position
	# Clamp the position of the camera between the min and max room.
	var target_position = Vector2()
	target_position.x = clamp(t_pos.x, _min_room.x, _max_room.x)
	target_position.y = clamp(t_pos.y, _min_room.y, _max_room.y)
	return target_position

func update_room_size(min_room: Vector2, max_room: Vector2):
	_min_room = min_room * _room_size + 0.5 * _room_size
	_max_room = max_room * _room_size + 0.5 * _room_size
	return
