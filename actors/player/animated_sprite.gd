extends AnimatedSprite


func animate(velocity: Vector2) -> void:
	# Flip sprite.
	if abs(velocity.x) > 0.05:
		flip_h = velocity.x < 0
	# Chagne animation.
	animation = "run" if velocity.length() > 0.1 else "idle"
	return
