class_name ZIndexer
extends Node2D

export (NodePath) var _target_node = ""

onready var _camera: Camera2D = get_tree().get_nodes_in_group("camera")[0]
onready var _target: Node2D = get_node(_target_node)


func _process(delta) -> void:
	_target.z_index = _get_z_index()
	return


func _get_z_index() -> int:
	return int(_target.global_position.y - _camera.global_position.y + 64)
