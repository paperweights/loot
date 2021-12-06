class_name ZIndexer
extends Node2D

const OFFSET=64

onready var _camera: Camera2D = get_tree().get_nodes_in_group("camera")[0]
onready var _parent: Node2D = get_node("../")


func _process(_delta):
	_parent.z_index = _get_z_index()


func _get_z_index() -> int:
	var z_index = int(global_position.y - _camera.global_position.y + OFFSET)
	return z_index
