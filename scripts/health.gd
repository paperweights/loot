class_name Health
extends Node

signal died

export(int) var _max_health = 8

var _health = _max_health


func heal(amount: int) -> void:
	# Amount can't be below 0.
	_change_health(max(0, amount))
	return


func hurt(amount: int) -> void:
	# Amount can't be above 0.
	_change_health(min(0, amount))
	return


func _change_health(amount: int) -> void:
	_health += amount
	_health = clamp(_health, 0, _max_health)
	# Die if health is too low.
	if _health == 0:
		emit_signal("died")
	return
