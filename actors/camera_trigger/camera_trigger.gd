extends Area2D

const CAMERA_2D = preload("res://actors/camera/camera2d.gd")
const ROOM_SIZE = CAMERA_2D.ROOM_SIZE
const HALF_ROOM = CAMERA_2D.HALF_ROOM

export (Vector2) var _min_room
export (Vector2) var _max_room

onready var _collision_shape = $CollisionShape2D


func _ready() -> void:
	_update_collision_shape()
	return


func _update_collision_shape() -> void:
	# half of the room size in pixels.
	var room_size = (_max_room - _min_room + Vector2(1, 1)) * HALF_ROOM
	# Apply pos and extents
	var shape = RectangleShape2D.new()
	shape.extents = room_size - Vector2(8, 8)
	_collision_shape.shape = shape
	_collision_shape.position = _min_room * ROOM_SIZE + room_size
	return


func _on_CameraTrigger_body_entered(body: Node) -> void:
	get_tree().call_group("camera", "update_room_size", _min_room, _max_room)
	return
