extends "res://actors/entity/entity.gd"

const DISTANCE_THRESHOLD = 4 * 4
const RETARGET_THRESHOLD = 16 * 16

var _path: PoolVector2Array

onready var _path_finder: Node = get_node("../PathFinder")
onready var _target: Node2D = get_node("../Player")


func _ready():
	_input = Vector2(1, 0)


func _physics_process(_delta):
	# Find a new path
	if _path.empty():
		_retarget()
		return
	var distance = global_position.distance_squared_to(_path[0])
	# Move if got close to target
	if distance < DISTANCE_THRESHOLD:
		_move()
	# Retarget if moved to far away
	elif distance > RETARGET_THRESHOLD:
		print("too far")
		_retarget()


func _move():
	var target: Vector2 = _path[0]
	print('moving to ', target)
	_path.remove(0)
	_input = (target - global_position).normalized()


func _retarget():
	_path = _path_finder.find_path(global_position, _target.global_position)
	_move()
