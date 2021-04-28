extends Node2D

export var _target_length = 32
export (float, 0, 1) var _lerp_speed = 0.02

var _target_flicker = 0
var _flicker = 0
var _length = 0

onready var _light_mesh = $LightMesh
onready var _shade_masks = $ShadeMasks
onready var _camera: Camera2D = get_tree().get_nodes_in_group("camera")[0]


func _process(delta) -> void:
	_length = lerp(_length, _target_length, _lerp_speed)
	_flicker = lerp(_flicker, _target_flicker, 0.02)
	_light_mesh.update_mesh(_length - _flicker)
	_shade_masks.update_masks(_length - _flicker)
	return


func _on_Timer_timeout():
	_target_flicker = rand_range(-4, 4)
	pass
