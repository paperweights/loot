class_name ShadeMasks
extends Node2D

const MASK_COUNT = 4
const LIGHT_SPRITE = preload("res://light_source/light_source/light_sprite.tscn")

onready var _masks = []
onready var _shade_viewports = get_tree().get_nodes_in_group("shade_viewport")


func _ready() -> void:
	for i in range(MASK_COUNT):
		var new_light = LIGHT_SPRITE.instance()
		_masks.append(new_light)
		_shade_viewports[i].add_child(new_light)
	return


func update_masks(layers: PoolRealArray, flicker: float, camera_position: Vector2) -> void:
	var count = len(_masks)
	var length = 0
	for i in range(count):
		length += layers[i]
		# calculate the scale of the mask
		var s = (length + flicker) / 64.0
		_masks[i].scale = Vector2(s, s)
		_masks[i].position = global_position - camera_position + Vector2(128, 128)
	return
