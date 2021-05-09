extends Node2D

signal updated(length)

export var _target_length = 48
export (float, 0, 1) var _lerp_speed = 0.02

var _target_flicker = 0
var _flicker = 0
var _length = 0

onready var _camera: Camera2D = get_tree().get_nodes_in_group("camera")[0]


func _process(delta) -> void:
	_length = lerp(_length, _target_length, _lerp_speed)
	_flicker = lerp(_flicker, _target_flicker, 0.02)
	emit_signal("updated", _length - _flicker)
	return


func _on_Timer_timeout():
	_target_flicker = rand_range(-4, 4)
	pass
