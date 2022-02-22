class_name Entity
extends KinematicBody2D

export (int) var _speed = 50

var _input: Vector2

onready var _sprite: AnimatedSprite = $AnimatedSprite


func _physics_process(_delta):
	# only move on input
	var velocity = _input * _speed
	var new_velocity = move_and_slide(velocity)
	# handle collisions
	for c in get_slide_count():
		var collision: KinematicCollision2D = get_slide_collision(c)
		if !collision:
			continue
		# push other kinematic bodies
		if collision.collider is KinematicBody2D:
			var opposite = collision.normal.dot(velocity.normalized()) <= -1
			if opposite:
				collision.collider.move_and_slide(velocity)
				new_velocity += collision.remainder
	# update animations
	_sprite.animate(new_velocity)
