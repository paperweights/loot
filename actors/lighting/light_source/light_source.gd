extends Node2D

export var _length = 32


onready var _light_mesh = $LightMesh
onready var _shade_masks = $ShadeMasks
onready var _camera: Camera2D = get_tree().get_nodes_in_group("camera")[0]


func _process(delta) -> void:
	_light_mesh.update_mesh(_length)
	_shade_masks.update_masks(_length)
	return
