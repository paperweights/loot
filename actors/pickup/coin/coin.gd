extends KinematicBody2D

export (float) var _gravity_scale = 0.1
export (float) var _bounce = 0.8
var _height = 0
var _y_velocity = -9

onready var _sprite = $Sprite


func _process(delta) -> void:
	_sprite.position = Vector2(0, _height)
	return


func _physics_process(delta) -> void:
	_y_velocity += 9.8 * _gravity_scale
	_height += _y_velocity
	if _height >= 0:
		_height = 0
		_y_velocity *= -_bounce
	return
