extends Node2D

const CELL_SIZE = Vector2(8, 8)
const ROOM_SIZE = Vector2(16, 16)
const ROOMS = [
	preload("res://prefabs/rooms/1x1/tdlr/0.tscn"),
	preload("res://prefabs/rooms/1x1/tdlr/1.tscn"),
	preload("res://prefabs/rooms/1x1/tdlr/8.tscn"),
]

onready var _nav: Navigation2D = get_node("../Navigation2D")
onready var _floor: TileMap = $Floor
onready var _walls: TileMap = $Walls
onready var _tops: TileMap = $Tops


func _ready():
	spawn_room(2, Vector2(0, 0))
	spawn_room(1, Vector2(1, 0))
	return


func spawn_room(index: int, pos: Vector2):
	var room = ROOMS[index].instance()
	# Combine tilemaps
	var floors: TileMap = room.get_node("Floors")
	var walls: TileMap = room.get_node("Walls")
	var tops: TileMap = room.get_node("Tops")
	var nav_poly: NavigationPolygonInstance = room.get_node("NavMesh")
	var tilemap_offset = pos * ROOM_SIZE
	_blit_tilemap(floors, _floor, tilemap_offset)
	_blit_tilemap(walls, _walls, tilemap_offset)
	_blit_tilemap(tops, _tops, tilemap_offset)
	# Add navigation
	var t = Transform2D.IDENTITY.translated(pos * ROOM_SIZE * CELL_SIZE)
	print(t)
	_nav.navpoly_add(nav_poly.navpoly, t)
	return


func _blit_tilemap(src: TileMap, dst: TileMap, offset: Vector2):
	var cells = src.get_used_cells()
	for cell in cells:
		var tile = src.get_cell(cell[0], cell[1])
		var x = cell[0] + offset.x
		var y = cell[1] + offset.y
		dst.set_cell(x, y, tile)
	dst.update_bitmask_region()
	return
