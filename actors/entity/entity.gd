extends KinematicBody2D

export(int) var _speed = 50

var _input: Vector2

onready var _sprite: AnimatedSprite = $AnimatedSprite


func _physics_process(_delta):
	# Only move on input.
	var velocity = _input * _speed
	velocity = move_and_slide(velocity)
	_sprite.animate(velocity)
