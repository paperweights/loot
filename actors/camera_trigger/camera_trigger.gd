extends Area2D

const ROOM_SIZE = Vector2(128, 128)
const HALF_ROOM = ROOM_SIZE / 2

export (Vector2) var _position
export (Vector2) var _size

onready var _collision_shape = $CollisionShape2D
onready var _max_room = _position + _size - Vector2(1, 1)


func _ready() -> void:
	_update_collision_shape()


func _update_collision_shape() -> void:
	# half of the room size in pixels.
	var room_size = _size * HALF_ROOM
	# Apply pos and extents
	var shape = RectangleShape2D.new()
	shape.extents = room_size - Vector2(4, 2)
	_collision_shape.shape = shape
	_collision_shape.position = _position * ROOM_SIZE + room_size


func _update_camera():
	get_tree().call_group("camera", "update_room_size", _position, _max_room)


func _on_CameraTrigger_body_entered(body):
	print(body)
	_update_camera()
