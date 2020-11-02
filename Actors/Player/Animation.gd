extends AnimatedSprite

func animate(velocity: Vector2):
	# Change current animation.
	animation = "Idle" if velocity == Vector2() else "Run"
	# Flip based on direction.
	if velocity.x != 0:
		flip_h = velocity.x < 0
	return
