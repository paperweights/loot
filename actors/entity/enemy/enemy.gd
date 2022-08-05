extends "res://actors/entity/entity.gd"

const DISTANCE_THRESHOLD = pow(2, 2)
const PLAYER_THRESHOLD = pow(12, 2)

var _path: Array
var _moving: bool

onready var _target: Node2D = get_node('../Player')
onready var _nav: Navigation2D = get_node('../../Navigation2D')


func _physics_process(_delta):
	if _moving:
		_move()
	else:
		_update_path()


func _move():
	var last_point = position
	var size = _path.size()
	if size:
		var distance = last_point.distance_squared_to(_path[0])
		_input = (_path[0] - last_point).normalized()
		# keep moving if more distance to cover
		var threshold = PLAYER_THRESHOLD if size == 1 else DISTANCE_THRESHOLD
		if distance <= threshold:
			position = last_point
			last_point = _path[0]
			_path.remove(0)
		return
	# Stop moving once target reached
	_moving = false
	_input = Vector2()
	return


func _update_path():
	var target_pos = _nav.get_closest_point(_target.position)
	# Skip if too close already
	if position.distance_squared_to(target_pos) < PLAYER_THRESHOLD:
		return
	_path = _nav.get_simple_path(position, target_pos)
	if _path:
		_path.remove(0)
	_moving = true
