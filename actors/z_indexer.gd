class_name ZIndexer
extends Node2D

export (NodePath) var _target_node = ""

onready var _target: Node2D = get_node(_target_node)


func _process(delta) -> void:
	_target.z_index = _target.global_position.y
	return
