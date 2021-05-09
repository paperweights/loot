extends Node2D

const LIGHT_STEP = 3
const LIGHT_SPRITE = preload("res://actors/lighting/light_source/light_sprite.tscn")

onready var _masks = []
onready var _shade_viewports = get_tree().get_nodes_in_group("shade_viewport")
onready var _camera: Camera2D = get_tree().get_nodes_in_group("camera")[0]


func _ready() -> void:
	for i in range(3):
		var new_light = LIGHT_SPRITE.instance()
		_masks.append(new_light)
		_shade_viewports[i].add_child(new_light)
	return


func update_masks(length: float) -> void:
	var count = len(_masks)
	for i in range(count):
		# Calculate the scale of the light layer.
		var s = (length - ((count - i) * LIGHT_STEP)) / 64.0
		_masks[i].scale = Vector2(s, s)
		_masks[i].position = global_position - _camera.global_position + Vector2(128, 128)
	return


func _on_LightSource_updated(length):
	update_masks(length)
	return
