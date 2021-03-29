extends Node2D

var _rays = 360
var _base_length = 30
var _flicker_length = 4
var _rng = RandomNumberGenerator.new()

onready var _sprite = Sprite.new()
onready var _raycast = $RayCast2D
onready var _camera = get_tree().get_nodes_in_group('Camera')[0]
onready var _length = _get_flicker()
onready var _vectors = _get_vectors()
onready var _lightTexture = load("res://Actors/LightSource/LightTexture.png")

func _ready():
	var viewport = get_tree().get_nodes_in_group('LightViewport')[0]
	viewport.add_child(_sprite)
	return

func _process(delta):
	_update_sprite_position()
	return

func _physics_process(delta):
	# Check for raycast collisions.
	var points = _get_light_points(_length)
	var arrayMesh = _get_array_mesh(points)
	_update_sprite_mesh(arrayMesh)
	return

func _get_light_points(length: float) -> Array:
	var points = []
	for v in _vectors:
		var vector = v * length
		_raycast.set_cast_to(vector)
		_raycast.force_raycast_update()
		if _raycast.is_colliding():
			var collision_pos = _raycast.get_collision_point() - global_position
			points.append(collision_pos)
		else:
			points.append(vector)
	return points

func _get_array_mesh(points: Array) -> ArrayMesh:
	# Generate the vertices.
	var vertices = PoolVector2Array()
	for p in range(len(points)):
		vertices.push_back(points[p])
		vertices.push_back(Vector2())
		vertices.push_back(points[p - 1])
	# Create array to store vertices.
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	# Create array mesh.
	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return array_mesh

func _get_flicker() -> float:
	return _base_length + _rng.randf_range(0, _flicker_length)

func _on_Flicker_timeout():
	_length = _get_flicker()
	return

func _get_vectors() -> Array:
	var vectors = []
	var interval = (2 * PI) / _rays
	for r in range(_rays):
		var angle = interval * r
		var vector = Vector2(cos(angle), sin(angle))
		vectors.append(vector)
	return vectors

func _update_sprite_position():
	var cameraPosition = _camera.global_position
	var difference = global_position - cameraPosition
	var target_position = Vector2(64, 64) + difference
	_sprite.position = target_position
	return

func _update_sprite_mesh(array_mesh: ArrayMesh):
	var meshTexture = MeshTexture.new()
	meshTexture.base_texture = _lightTexture
	meshTexture.mesh = array_mesh
	_sprite.texture = meshTexture
	return
