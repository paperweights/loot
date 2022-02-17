extends Node2D

const FLICKER_SPEED = 0.02

export (PoolRealArray) var _layers
export (int) var _flicker_intensity = 1

var _target_flicker: float
var _flicker: float

onready var _light_mesh: LightMesh = $LightMesh
onready var _shade_masks: ShadeMasks = $ShadeMasks
onready var _camera: Camera2D = get_tree().get_nodes_in_group("camera")[0]


func _process(delta) -> void:
	_flicker = lerp(_flicker, _target_flicker, FLICKER_SPEED)
	var camera_position = _camera.global_position
	var length = _get_layers_length(_layers, _flicker)
	_light_mesh.update_mesh(length, camera_position)
	_shade_masks.update_masks(_layers, _flicker, camera_position)
	return


func _get_layers_length(layers: PoolRealArray, flicker: float) -> float:
	var length = flicker
	for layer in layers:
		length += layer
	return length


func _on_Timer_timeout():
	_target_flicker = rand_range(-_flicker_intensity, _flicker_intensity)
	pass
