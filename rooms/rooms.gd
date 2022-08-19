"""
Room Generator
"""
extends Node2D

enum Connection {
	Nothing = -1, # no wall or connection
	Solid, # solid wall
	Exit, # dungeon exit
	Pass, # passage
}

const CELL_SIZE = Vector2(8, 8)
const ROOM_SIZE = Vector2(16, 16)
const TILEMAPS = ["Floors", "Walls", "Tops"]
# borders
const BORDERS = [
	{
		'scene': preload("res://rooms/borders/horizontal.tscn"),
		'offset': Vector2(),
		'connections': {
			'solid': preload("res://rooms/borders/solid.tscn"),
			'passage': preload("res://rooms/borders/passage.tscn"),
		}
	},
	{
		'scene': preload("res://rooms/borders/vertical.tscn"),
		'offset': Vector2(),
	},
	{
		'scene': preload("res://rooms/borders/horizontal.tscn"),
		'offset': Vector2(0, 16),
	},
	{
		'scene': preload("res://rooms/borders/vertical.tscn"),
		'offset': Vector2(16,0),
	},
]
const OFFSETS = [Vector2.UP, Vector2.LEFT, Vector2.DOWN, Vector2.RIGHT]
const STARTING_ROOM = {
	'scene': preload("res://rooms/prefabs/starting_room.tscn"),
	'cells': {
		Vector2(): [Connection.Pass, Connection.Pass, Connection.Pass,
		Connection.Pass],
	}
}
const PALETTE = [
	{
		'scene': preload("res://rooms/prefabs/template.tscn"),
		'cells': {
			Vector2(): [Connection.Pass, Connection.Pass, Connection.Pass,
			Connection.Pass],
		},
	},
]

export(Array, Dictionary) var _veins = [
	{
		'length': 3,
		'palette': PALETTE,
	},
]

onready var _tilemaps = [$Floor, $Walls, $Tops]


func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rooms = _generate_layout(rng)
	_place_rooms(rooms)
	_update_tilemaps()
	return


func _generate_layout(rng: RandomNumberGenerator) -> Dictionary:
	"""
	generate the dungeon layout by keeping track of the rooms to spawn and the
	location to spawn them at. This will be followed up by a seperate function
	that just draws the rooms and the connections to the tilemaps.
	"""
	var rooms = {}
	# spawn the starting room
	rooms[Vector2()] = STARTING_ROOM
	# build each vein
	for vein in _veins:
		var palette: Array = vein['palette']
		# build a specified number of rooms
		for r in range(vein['length']):
			var room_order = _shuffle(range(len(palette)), rng)
			# pick a room prefab to build
			for p in room_order:
				var room = palette[p]
				# figure out where to place the room
	return rooms


func _place_rooms(rooms: Dictionary) -> void:
	for location in rooms.keys():
		var room = rooms[location]
		_spawn_room(room['scene'], location)
		_spawn_borders(room['cells'], location)
	return


func _add_available(from: Dictionary, to: Dictionary) -> void:
	for key in from:
		to[key] = from[key]
	return


func _spawn_room(room: PackedScene, location: Vector2) -> void:
	var offset = location * ROOM_SIZE
	_blit_tilemaps(room.instance(), offset)
	return


func _spawn_borders(cells: Dictionary, location: Vector2) -> void:
	var offset = location * ROOM_SIZE
	for cell in cells.keys():
		var connections = cells[cell]
		for c in range(4):
			var connection = connections[c]
			if connection == Connection.Nothing:
				continue
			var border = BORDERS[c]
			var border_offset = offset + border['offset']
			_blit_tilemaps(border['scene'].instance(), border_offset)
			if c > 0:
				continue
			var passage: PackedScene = null
			match connection:
				Connection.Solid:
					passage = border['connections']['solid']
				Connection.Pass:
					passage = border['connections']['passage']
			if passage:
				_blit_tilemaps(passage.instance(), border_offset)
	return


func _blit_tilemap(src: TileMap, dst: TileMap, offset: Vector2) -> void:
	var cells = src.get_used_cells()
	for cell in cells:
		var tile = src.get_cellv(cell)
		dst.set_cellv(cell + offset, tile)
	return


func _blit_tilemaps(room: Node2D, offset: Vector2) -> void:
	for t in range(3):
		_blit_tilemap(room.get_node(TILEMAPS[t]), _tilemaps[t], offset)
	return


func _update_tilemaps() -> void:
	for tilemap in _tilemaps:
		tilemap.update_bitmask_region()
	return


func _shuffle(array: Array, rng: RandomNumberGenerator) -> Array:
	"""
	Fisher-Yates shuffle
	https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle#Modern_method
	"""
	var copy = array.duplicate()
	for i in range(len(array) - 1, 0, -1):
		var j = rng.randi_range(0, i)
		var value = copy[i]
		copy[i] = copy[j]
		copy[j] = value
	return copy
