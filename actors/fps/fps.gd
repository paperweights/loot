extends Label


func _process(delta) -> void:
	var frames = Engine.get_frames_per_second()
	text = "fps: %d" % frames
	return
