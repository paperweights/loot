extends Camera2D

export (float) var _intensity = 1
export (float) var _duration = 2

var rng = RandomNumberGenerator.new()

func _process(delta: float):
	# Reset once duration is 0.
	if _duration <= 0:
		offset = Vector2()
		return
	# Decrease duration otherwise.
	_duration -= delta
	# Get new random position.
	var random_pos = Vector2()
	random_pos.x = rng.randf_range(-_intensity, _intensity)
	random_pos.y = rng.randf_range(-_intensity, _intensity)
	offset = random_pos
	return
