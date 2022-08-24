"""
Room Generator
"""
extends Node2D

const CELL_SIZE = Vector2(8, 8)
const ROOM_SIZE = Vector2(16, 16)
const TILEMAPS = ["Floors", "Walls", "Tops"]
# borders
const BORDERS = [
	{
		'scene': preload("res://rooms/borders/horizontal.tscn"),
		'offset': Vector2(),
		'connections': [
			preload("res://rooms/borders/solid.tscn"),
			preload("res://rooms/borders/passage.tscn"),
		]
	},
	{
		'scene': preload("res://rooms/borders/vertical.tscn"),
		'offset': Vector2(),
		'connections': [
			preload("res://rooms/borders/solid_v.tscn"),
			preload("res://rooms/borders/passage_v.tscn"),
		]
	},
	{
		'scene': preload("res://rooms/borders/horizontal.tscn"),
		'offset': Vector2(0, 16),
		'connections': [
			preload("res://rooms/borders/solid.tscn"),
			preload("res://rooms/borders/passage.tscn"),
		]
	},
	{
		'scene': preload("res://rooms/borders/vertical.tscn"),
		'offset': Vector2(16,0),
		'connections': [
			preload("res://rooms/borders/solid_v.tscn"),
			preload("res://rooms/borders/passage_v.tscn"),
		]
	},
]
const OFFSETS = [Vector2.UP, Vector2.LEFT, Vector2.DOWN, Vector2.RIGHT]
const STARTING_ROOM = {
	'scene': preload("res://rooms/prefabs/starting_room.tscn"),
	'cells': {
		Vector2(): 0b1111,
	}
}
const PALETTE = [
	{
		'scene': preload("res://rooms/prefabs/template.tscn"),
		'cells': {
			Vector2(): 0b1111,
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


var _rng: RandomNumberGenerator


func _init():
	_rng = RandomNumberGenerator.new()
	_rng.randomize()
	return


func _ready():
	var rooms = _generate_layout()
	_place_rooms(rooms)
	_update_tilemaps()
	return


func _generate_layout() -> Dictionary:
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
		var connections = _shuffle(_get_connections(rooms))
		# build a specified number of rooms
		for _r in range(vein['length']):
			var room_order = _shuffle(range(len(palette)))
			var location = _generate_room(rooms, palette, room_order, connections)
			# if location isn't void, generation succeeded
			if location:
				# the next room in the vein branches off the current one
				var temp_rooms = {location: rooms[location]}
				connections = _shuffle(_get_connections(temp_rooms))
	return rooms


func _generate_room(rooms: Dictionary, palette: Array, room_order: Array, connections: Array):
	for r in room_order:
		var room = palette[r]
		for c in connections:
			var new_loc = c[0] + OFFSETS[c[1]]
			if _is_occupied(rooms, new_loc):
				continue
			rooms[new_loc] = room
			return new_loc
	return null


func _get_connections(rooms: Dictionary) -> Array:
	"""
	returns an Array of open connections where a connections is:
	[location: Vector2, direction: int]
	"""
	var connections = []
	for location in rooms:
		var cells = rooms[location]['cells']
		for cell in cells:
			var new_loc = location + cell
			var cons = cells[cell]
			for c in range(4):
				if not _get_connection(cons, c):
					continue
				if _is_occupied(rooms, new_loc + OFFSETS[c]):
					continue
				connections.append([new_loc, c])
	return connections


func _is_occupied(rooms: Dictionary, location: Vector2) -> bool:
	for r in rooms:
		var room = rooms[r]
		for c in room['cells']:
			if location == r + c:
				return true
	return false


func _place_rooms(rooms: Dictionary) -> void:
	for location in rooms:
		var room = rooms[location]
		_spawn_room(room['scene'], location)
		_spawn_borders(rooms, room['cells'], location)
	return


func _spawn_room(room: PackedScene, location: Vector2) -> void:
	var offset = location * ROOM_SIZE
	_blit_tilemaps(room.instance(), offset)
	return


func _spawn_borders(rooms: Dictionary, cells: Dictionary, location: Vector2) -> void:
	var offset = location * ROOM_SIZE
	for cell in cells.keys():
		var connections = cells[cell]
		for c in range(4):
			var connection = _get_connection(connections, c)
			if cell + OFFSETS[c] in cells:
				print('neighbour')
				continue
			var border = BORDERS[c]
			var border_offset = offset + border['offset']
			_blit_tilemaps(border['scene'].instance(), border_offset)
			# close of connections
			if not _is_occupied(rooms, location + cell + OFFSETS[c]):
				connection = false
			_blit_tilemaps(border['connections'][int(connection)].instance(), border_offset)
	return


func _get_connection(connections: int, c: int) -> bool:
	return connections & 1 << c != 0


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


func _shuffle(array: Array) -> Array:
	"""
	Fisher-Yates shuffle
	https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle#Modern_method
	"""
	var copy = array.duplicate()
	for i in range(len(array) - 1, 0, -1):
		var j = _rng.randi_range(0, i)
		var value = copy[i]
		copy[i] = copy[j]
		copy[j] = value
	return copy


func _add_available(from: Dictionary, to: Dictionary) -> void:
	for key in from:
		to[key] = from[key]
	return
