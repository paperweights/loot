extends Node2D

const CELL_SIZE = Vector2(8, 8)
const ROOM_SIZE = Vector2(16, 16)
const TILEMAPS = ["Floors", "Walls", "Tops"]
# borders
const BORDERS = [
	[Vector2(), preload("res://rooms/borders/horizontal.tscn")],
	[Vector2(), preload("res://rooms/borders/vertical.tscn")],
	[Vector2(0, 16), preload("res://rooms/borders/horizontal.tscn")],
	[Vector2(16, 0), preload("res://rooms/borders/vertical.tscn")],
]
const OFFSETS = [Vector2.UP, Vector2.LEFT, Vector2.DOWN, Vector2.RIGHT]

export(PackedScene) var _starting_room
export(Array, Dictionary) var _veins = [
	{
		'length': 3,
		'palette': load("res://rooms/palettes/palette.tres")
	},
]

onready var _tilemaps = [$Floor, $Walls, $Tops]


func _ready():
	_build()
	return


func _build(seed_: String = "") -> void:
	var rng = RandomNumberGenerator.new()
	if seed_:
		rng.set_seed(hash(seed_))
	else:
		rng.randomize()
		print('yeah')
	# keep track of available and occupied dungeon cells
	var occupied = PoolVector2Array([Vector2()])
	var available: Dictionary = {}
	# spawn starting room
	_add_available(_spawn_room(_starting_room, Vector2()), available)
	# build veins
	for vein in _veins:
		var palette: RoomPalette = vein['palette']
		var room_count = palette.get_length()
		for l in range(vein['length']):
			# pick the room to spawn
			var room = palette.get_room(rng.randi() % room_count)
			# pick the location
			var locations = available.keys()
			var location = locations[rng.randi() % len(locations)]
			occupied.push_back(location)
			_add_available(_spawn_room(room, location), available)
	# update bitmasks once all tilemap changes have been made
	for tilemap in _tilemaps:
		tilemap.update_bitmask_region()
	return


func _add_available(from: Dictionary, to: Dictionary) -> void:
	for key in from:
		to[key] = from[key]
	return


func _spawn_room(room: PackedScene, location: Vector2) -> Dictionary:
	var instance: DungeonRoom = room.instance()
	# Combine tilemaps
	var offset = location * ROOM_SIZE
	_blit_tilemaps(instance, offset)
	# Generate borders
	var available: Dictionary = {}
	for cell in instance.cells:
		var data: Dictionary = instance.cells[cell]
		for c in range(4):
			var type: int = data['connections'][c]
			# negative types make their own walls
			if type < 0:
				continue
			var border = BORDERS[c]
			_blit_tilemaps(border[1].instance(), border[0] + offset)
			# 0 and 1 don't connect
			if type < 2:
				continue
			var available_location: Vector2 = location + cell + OFFSETS[c]
			if available_location in available:
				available[available_location] += 1 << c
			else:
				available[available_location] = 1 << c
	return available


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
