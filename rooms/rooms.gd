"""
Room Generator
"""
extends Node2D

enum Connection {
	Up = 1,
	Left = 2,
	Down = 4,
	Right = 8,
	All = 15,
}

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
# NOTE: cells bitmask is in reverse order of OFFSETS
const OFFSETS = [Vector2.UP, Vector2.LEFT, Vector2.DOWN, Vector2.RIGHT]
const STARTING_ROOM = {
	'scene': preload("res://rooms/prefabs/starting_room.tscn"),
	'cells': {
		Vector2(): Connection.All,
	}
}
const PALETTE = [
	{
		'scene': preload("res://rooms/prefabs/template.tscn"),
		'cells': {
			Vector2(): Connection.All,
		},
	},
	{
		'scene': preload("res://rooms/prefabs/2x2/test.tscn"),
		'cells': {
			Vector2(): Connection.Up | Connection.Left,
			Vector2(1, 0): Connection.Up | Connection.Right,
			Vector2(0, 1): Connection.Left | Connection.Down,
			Vector2(1, 1): Connection.Down | Connection.Right,
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
	location to spawn them at. This will be followed up by a separate function
	that just draws the rooms and the connections to the tilemaps.
	"""
	# TODO: keep track of connections
	var rooms = {}
	# spawn the starting room
	rooms[Vector2()] = STARTING_ROOM
	for vein in _veins: # build each vein
		var palette: Array = vein['palette']
		var branch_rooms = _shuffle(rooms.keys())
		# build a specified number of rooms
		for _r in range(vein['length']):
			var new_room_location = _generate_room(rooms, palette, branch_rooms)
			if new_room_location:
				branch_rooms = [new_room_location]
	return rooms


func _generate_room(rooms: Dictionary, palette: Array, branch_rooms: Array):
	# pick a room to branch out off
	for branch_room_location in branch_rooms:
		# get list connections to branch out of
		var connections = _get_connections(rooms[branch_room_location]['cells'])
		_remove_occupied_connections(rooms, branch_room_location, connections)
		connections = _shuffle(connections)
		for connection in connections:
			# try to find a room that can connect
			var room_order = _shuffle(palette)
			for room in room_order:
				var room_connections = _get_connections(room['cells'])
				_remove_directional_connections(room_connections, connection[1])
				room_connections = _shuffle(room_connections)
				for room_connection in room_connections:
					var new_room_location = branch_room_location + connection[0] + OFFSETS[connection[1]] - room_connection[0]
					var valid: bool = true
					for new_room_cell in room['cells']:
						if _is_occupied(rooms, new_room_location + new_room_cell):
							valid = false
							break
					if not valid:
						continue
					rooms[new_room_location] = room
					return new_room_location
	return


func _get_connections(cells: Dictionary) -> Array:
	"""
	get all open connections of a room
	"""
	var open_connections = []
	for cell in cells:
		var cons = cells[cell]
		for c in range(4):
			# skip closed connections
			if not _get_connection(cons, c):
				continue
			open_connections.push_back([cell, c])
	return open_connections


func _remove_occupied_connections(rooms: Dictionary, location: Vector2,
connections: Array) -> void:
	for c in range(len(connections) - 1, 0, -1):
		var conn = connections[c]
		if _is_occupied(rooms, location + conn[0] + OFFSETS[conn[1]]):
			connections.pop_at(c)
	return


func _remove_directional_connections(connections: Array, direction: int) -> void:
	direction = (direction + 2) % 4
	for c in range(len(connections) - 1, -1, -1):
		var conn = connections[c]
		if conn[1] != direction:
			connections.pop_at(c)
	return


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
	# TODO: borders shared by two rooms are drawn twice
	var location_offset = location * ROOM_SIZE
	for cell in cells.keys():
		var cell_offset = cell * ROOM_SIZE
		var connections = cells[cell]
		for c in range(4):
			var connection = _get_connection(connections, c)
			# don't create borders with other cells from the same room
			if cell + OFFSETS[c] in cells:
				continue
#			if connection == false: # DEBUG
#				print(location, ' ', cell, ' ', connections)
			var border = BORDERS[c]
			var border_offset = location_offset + cell_offset + border['offset']
			_blit_tilemaps(border['scene'].instance(), border_offset)
			# close of connections
			if not _is_occupied(rooms, location + cell + OFFSETS[c]):
				connection = false
			_blit_tilemaps(border['connections'][int(connection)].instance(), border_offset)
	return


func _get_connection(connections: int, c: int) -> bool:
	"""
	check if a connection is open in a certain diretion
	"""
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
	# TODO: randomise floor tiles
	for tilemap in _tilemaps:
		tilemap.update_bitmask_region()
	return


func _shuffle(array: Array) -> Array:
	"""
	Shuffle using a random number generator
	Fisher-Yates shuffle
	https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle#Modern_method
	"""
	var copy = array.duplicate()
	# skip shuffling if not enough elements
	if len(copy) < 2:
		return copy
	for i in range(len(copy) - 1, 0, -1):
		var j = _rng.randi_range(0, i)
		var value = copy[i]
		copy[i] = copy[j]
		copy[j] = value
	return copy
