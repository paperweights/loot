extends KinematicBody2D

signal moved(velocity)
signal idled

export var speed = 50


func _physics_process(delta: float) -> void:
	var input = _get_input()
	# Only move on input.
	if input != Vector2():
		var velocity = input * speed
		velocity = move_and_slide(velocity)
		emit_signal("moved", velocity)
	else:
		emit_signal("idled")
	return


func _get_input() -> Vector2:
	return Vector2(
		-Input.get_action_strength("ui_left") + Input.get_action_strength("ui_right"),
		-Input.get_action_strength("ui_up") + Input.get_action_strength("ui_down")
	)
