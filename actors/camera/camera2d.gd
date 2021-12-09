extends Camera2D

export(int) var _shake_intensity = 8
export(float, 0, 1) var _follow_speed = 0.1
export(float, 0, 1) var _offset_speed = 0.1
export(NodePath) var _target_node

var _target_offset: Vector2

onready var _target: Node2D = get_node(_target_node)
onready var _timer: Timer = $ShakeInterval


func _ready():
	position = _target.position


func _process(_delta):
	position = _vector2_lerp(position, _target.position, _follow_speed)
	offset = _vector2_lerp(offset, _target_offset, _offset_speed)
	return


func _vector2_lerp(from: Vector2, to: Vector2, weight: float) -> Vector2:
	return Vector2(
		lerp(from.x, to.x, weight),
		lerp(from.y, to.y, weight)
	)


func _shake_offset() -> Vector2:
	return Vector2(
		rand_range(-_shake_intensity, _shake_intensity),
		rand_range(-_shake_intensity, _shake_intensity)
	)


func _on_ShakeInterval_timeout():
	_target_offset = _shake_offset()
