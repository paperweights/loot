extends Area2D

const ROOM_SIZE = preload("res://actors/camera/camera2d.gd").ROOM_SIZE

export (Vector2) var _min_room
export (Vector2) var _max_room

onready var _collision_shape = $CollisionShape2D


func _ready() -> void:
	_update_collision_shape()
	return


func _update_collision_shape() -> void:
	var target_pos = _max_room - _min_room + Vector2(1, 1) * Vector2(64, 64)
	var shape = RectangleShape2D.new()
	shape.extents = target_pos - Vector2(8, 8)
	_collision_shape.shape = shape
	_collision_shape.position = target_pos
	return


func _on_CameraTrigger_body_entered(body: Node) -> void:
	get_tree().call_group("camera", "update_room_size", _min_room, _max_room)
	return
