extends Node2D

const MESH_OFFSET = Vector2(128, 128)
const LIGHT_SPRITE = preload("res://actors/lighting/light_source/light_sprite.tscn")

export var _length = 32
export var _light_step = 3

var _mesh_instance = MeshInstance2D.new()

onready var _ray = $RayCast2D
onready var _camera: Camera2D = get_tree().get_nodes_in_group("camera")[0]
onready var _shade_viewports = get_tree().get_nodes_in_group("shade_viewport")
onready var _lights = []


func _ready():
	var light_viewport : Node = get_tree().get_nodes_in_group("light_viewport")[0]
	light_viewport.add_child(_mesh_instance)
	_create_lights()
	return


func _process(delta) -> void:
	_update_mesh()
	_update_lights()
	return


func _create_lights() -> void:
	for i in range(3):
		var new_light = LIGHT_SPRITE.instance()
		_lights.append(new_light)
		_shade_viewports[i].add_child(new_light)
	return


func _update_lights() -> void:
	var count = len(_lights)
	for i in range(count):
		# Calculate the scale of the light layer.
		var s = (_length - ((count - i) * _light_step)) / 64.0
		_lights[i].scale = Vector2(s, s)
		_lights[i].position = global_position - _camera.global_position + MESH_OFFSET
	return


func _update_mesh() -> void:
	# Get ray intersections.
	var points = _ray.cast_points(_length)
	# Generate a mesh for the sprite.
	var array_mesh = _get_array_mesh(points)
	_mesh_instance.mesh = array_mesh
	_mesh_instance.position = global_position - _camera.global_position + MESH_OFFSET
	return


func _get_array_mesh(points: PoolVector2Array) -> ArrayMesh:
	# Create vertices.
	var vertices = PoolVector3Array()
	vertices.push_back(Vector3())
	for i in range(len(points)):
		vertices.push_back(_to_vector3(points[i]))
	# Create indices.
	var indices = PoolIntArray()
	for i in range(len(points)):
		indices.push_back(0)
		indices.push_back(i + 1)
		indices.push_back((i + 1) % len(points) + 1)
	# Create surface array.
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_INDEX] = indices
	# Create array mesh.
	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return array_mesh


func _to_vector3(vector: Vector2) -> Vector3:
	return Vector3(vector.x, vector.y, 0)
