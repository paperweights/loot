extends Camera2D

const ROOM_SIZE = Vector2(128, 128)
const HALF_ROOM = ROOM_SIZE / 2

export var _shake_intensity = 2
export(float, 0, 1) var _follow_speed = 0.1
export(float, 0, 1) var _offset_speed = 0.05
export(NodePath) var _target_node
var _min_room = Vector2()
var _max_room = Vector2()
var _target_offset = Vector2()

onready var _target: Node2D = get_node(_target_node)
onready var _timer = $ShakeInterval


func _init() -> void:
	update_room_size(_min_room, _max_room)
	return


func _ready() -> void:
	position = _get_target_position()
	return


func _process(delta) -> void:
	position = _vector2_lerp(position, _get_target_position(), _follow_speed)
	offset = _vector2_lerp(offset, _target_offset, _offset_speed)
	return


func _vector2_lerp(from: Vector2, to: Vector2, weight: float) -> Vector2:
	return Vector2(
		lerp(from.x, to.x, weight),
		lerp(from.y, to.y, weight)
	)


func _get_target_position() -> Vector2:
	return Vector2(
		clamp(_target.position.x, _min_room.x, _max_room.x),
		clamp(_target.position.y, _min_room.y, _max_room.y)
	)


func _shake_offset() -> Vector2:
	return Vector2(
		rand_range(-_shake_intensity, _shake_intensity),
		rand_range(-_shake_intensity, _shake_intensity)
	)


func update_room_size(min_room: Vector2, max_room: Vector2) -> void:
	_min_room = min_room * ROOM_SIZE + HALF_ROOM
	_max_room = max_room * ROOM_SIZE + HALF_ROOM
	return


func _on_ShakeInterval_timeout() -> void:
	_target_offset = _shake_offset()
	return
