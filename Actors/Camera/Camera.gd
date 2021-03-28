extends Camera2D

# Shake.
export (float) var _intensity = 1
export (float) var _duration = 2
var _rng = RandomNumberGenerator.new()
# Follow.
export (NodePath) var _target_node = ""
export (Vector2) var _min_room = Vector2()
export (Vector2) var _max_room = Vector2()
onready var _target = get_node(_target_node)
var _room_size = Vector2(128, 128)

func _ready():
	update_room_size(_min_room, _max_room)
	position = _get_target_pos()
	return

func _process(delta: float) -> void:
	#offset = _get_offset(delta)
	position = _get_target_pos()
	return

func _get_offset(delta: float) -> Vector2:
	if _duration <= 0:
		return Vector2()
	_duration -= delta
	return Vector2(
		_rng.randf_range(-_intensity, _intensity),
		_rng.randf_range(-_intensity, _intensity)
	)

func _get_target_pos() -> Vector2:
	var t_pos = _target.position
	# Clamp the position of the camera between the min and max room.
	return Vector2(
		clamp(t_pos.x, _min_room.x, _max_room.x),
		clamp(t_pos.y, _min_room.y, _max_room.y)
	)

func update_room_size(min_room: Vector2, max_room: Vector2) -> void:
	var half_room = 0.5 * _room_size
	_min_room = min_room * _room_size + half_room
	_max_room = max_room * _room_size + half_room
	return
