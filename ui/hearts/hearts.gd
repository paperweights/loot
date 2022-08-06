class_name Hearts
extends GridContainer

const HEARTS = {
	"Full": preload("res://ui/hearts/sprites/full.png"),
	"Half": preload("res://ui/hearts/sprites/half.png"),
	"Empty": preload("res://ui/hearts/sprites/empty.png"),
}
const HEART_RECT = preload("res://ui/hearts/heart_rect.tscn")

var _heart_rects = []


func _init_hearts(max_health: int):
	# Destroy current hearts.
	for child in get_children():
		child.queue_free()
	_heart_rects = []
	# Figure out how many hearts will be needed.
	var heart_count = ceil(max_health / 2.0)
	# Create new hearts.
	for h in range(heart_count):
		var new_heart_texture_rect = HEART_RECT.instance()
		add_child(new_heart_texture_rect)
		_heart_rects.append(new_heart_texture_rect)


func _update_hearts(health: int):
	var health_threshold = 2
	for heart_texture_rect in _heart_rects:
		if health >= health_threshold:
			heart_texture_rect.texture = HEARTS["Full"]
		elif health == health_threshold - 1:
			heart_texture_rect.texture = HEARTS["Half"]
		else:
			heart_texture_rect.texture = HEARTS["Empty"]
		health_threshold += 2


func max_health_changed(max_health: int):
	_init_hearts(max_health)


func health_changed(health: int):
	_update_hearts(health)
