extends KinematicBody2D

export var _speed = 50

onready var _sprite = $AnimatedSprite


func _physics_process(delta: float) -> void:
	var input = _get_input()
	# Only move on input.
	var velocity = input * _speed
	velocity = move_and_slide(velocity)
	get_tree().call_group("player_sprite", "animate", velocity)
	return


func _get_input() -> Vector2:
	return Vector2(
		-Input.get_action_strength("ui_left") + Input.get_action_strength("ui_right"),
		-Input.get_action_strength("ui_up") + Input.get_action_strength("ui_down")
	)
