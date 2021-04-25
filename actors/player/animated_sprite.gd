extends AnimatedSprite


func _on_Player_moved(velocity: Vector2):
	# Flip sprite.
	if abs(velocity.x) > 0.05:
		flip_h = velocity.x < 0
	animation = "run"
	return


func _on_Player_idled():
	animation = "idle"
	return
