class_name Health
extends Node

signal health_changed(health)
signal max_health_changed(max_health)
signal died

export(int) var _max_health = 6

onready var _health = _max_health


func _ready():
	# Update UI
	get_tree().call_group("hearts", "max_health_changed", _max_health)
	get_tree().call_group("hearts", "health_changed", _health)
	hurt(3)


func get_max_health() -> int:
	return _max_health


func get_health() -> int:
	return _health


func heal(amount: int):
	# Amount can't be below 0
	_change_health(max(0, amount))


func hurt(amount: int):
	# Amount can't be above 0
	_change_health(min(0, -amount))


func _change_health(amount: int):
	_health += amount
	_health = clamp(_health, 0, _max_health)
	# Die if health is too low.
	if _health == 0:
		emit_signal("died")
	else:
		emit_signal("health_changed", _health)
		get_tree().call_group("hearts", "health_changed", _health)
