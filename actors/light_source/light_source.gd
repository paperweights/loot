extends Node2D

const HALF_ROOM = preload("res://actors/camera/camera2d.gd").HALF_ROOM

export (int) var _length = 40

var _mesh_instance = MeshInstance2D.new()

onready var _ray = $RayCast2D
onready var _camera: Camera2D = get_tree().get_nodes_in_group("camera")[0]


func _ready():
	var light_viewport : Node = get_tree().get_nodes_in_group("light_viewport")[0]
	light_viewport.add_child(_mesh_instance)
	return


func _process(delta) -> void:
	_update_mesh()
	return


func _update_mesh() -> void:
	# Get ray intersections.
	var points = _ray.cast_points(_length)
	# Generate a mesh for the sprite.
	var array_mesh = _get_array_mesh(points)
	_mesh_instance.mesh = array_mesh
	_mesh_instance.position = global_position - _camera.global_position + HALF_ROOM
	return


func _get_array_mesh(points: PoolVector2Array) -> ArrayMesh:
	# Create vertices.
	var vertices = PoolVector3Array()
	vertices.push_back(_to_vector3(position))
	for i in range(len(points)):
		vertices.push_back(_to_vector3(points[i]))
	# Create indices.
	var indices = PoolIntArray()
	for i in range(len(points)):
		indices.push_back(0)
		indices.push_back(i + 1)
		var i3 = i + 2 if i < len(points) - 1 else 1
		indices.push_back(i3)
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
