extends KinematicBody2D

export (float) var _speed = 60

var _input = Vector2()
var _velocity = Vector2()

func _physics_process(delta: float):
	_get_input()
	_move()
	$AnimatedSprite.animate(_velocity)
	return

func _get_input():
	_input = Vector2()
	_input.x = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	_input.y = Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
	# Normalize input.
	_input = _input.normalized()
	return

func _move():
	# Update velocity.
	_velocity = _input * _speed
	# Move and collide.
	move_and_slide(_velocity)
	return
