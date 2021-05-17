class_name HeartDisplay
extends GridContainer

const HEART_FULL = preload("res://ui/sprites/hearts/full.png")
const HEART_HALF = preload("res://ui/sprites/hearts/half.png")
const HEART_EMPTY = preload("res://ui/sprites/hearts/empty.png")
const HEART_TEXTURE_RECT = preload("res://ui/heart_texture_rect.tscn")

var _heart_texture_rects = []

onready var _player_health: Health = get_tree().get_nodes_in_group("player_health")[0]


func _ready() -> void:
	_init_hearts()


func _init_hearts() -> void:
	# Destroy current hearts.
	for child in get_children():
		child.queue_free()
	_heart_texture_rects = []
	# Figure out how many hearts will be needed.
	var heart_count = ceil(_player_health.get_max_health() / 2.0)
	# Create new hearts.
	for h in range(heart_count):
		var new_heart_texture_rect = HEART_TEXTURE_RECT.instance()
		add_child(new_heart_texture_rect)
		_heart_texture_rects.append(new_heart_texture_rect)
	_update_hearts(_player_health.get_health())


func _update_hearts(health: int) -> void:
	var health_threshold = 2
	for heart_texture_rect in _heart_texture_rects:
		if health >= health_threshold:
			heart_texture_rect.texture = HEART_FULL
		elif health == health_threshold - 1:
			heart_texture_rect.texture = HEART_HALF
		else:
			heart_texture_rect.texture = HEART_EMPTY
		health_threshold += 2
	return


func _on_PlayerHealth_health_changed(new_health: int) -> void:
	_init_hearts()
	return
