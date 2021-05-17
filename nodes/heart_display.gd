class_name HeartDisplay
extends GridContainer

const HEART_FULL = preload("res://ui/sprites/hearts/full.png")
const HEART_HALF = preload("res://ui/sprites/hearts/half.png")
const HEART_EMPTY = preload("res://ui/sprites/hearts/empty.png")

onready var _player_health: Health = get_tree().get_nodes_in_group("player_health")[0]


func _ready() -> void:
	_init_hearts()


func _init_hearts() -> void:
	# Destroy current hearts.
	for child in get_children():
		child.queue_free()
	# Figure out how many hearts will be needed.
	var heart_count = ceil(_player_health.get_max_health() / 2.0)
	# Create new hearts.
	var health = _player_health.get_health()
	print(health)
	for h in range(heart_count):
		var heart_health = h * 2 + 2
		print(heart_health)
		var new_heart = TextureRect.new()
		# Choose the texture based on current health.
		if health >= heart_health:
			new_heart.texture = HEART_FULL
		elif heart_health - 1 == health:
			new_heart.texture = HEART_HALF
		else:
			new_heart.texture = HEART_EMPTY
		add_child(new_heart)
