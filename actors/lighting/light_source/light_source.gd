extends Node2D

export var _length = 32

var _flicker = 0

onready var _light_mesh = $LightMesh
onready var _shade_masks = $ShadeMasks
onready var _camera: Camera2D = get_tree().get_nodes_in_group("camera")[0]


func _process(delta) -> void:
	_light_mesh.update_mesh(_length - _flicker)
	_shade_masks.update_masks(_length - _flicker)
	return


func _on_Timer_timeout():
	_flicker = rand_range(0, 1)
	pass
