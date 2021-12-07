extends Node

const MAX_TRIES = 300
const CELL_SIZE = Vector2(8, 8)
const HALF_CELL = CELL_SIZE / 2

onready var _floor: TileMap = get_node("../Floor")
onready var _walls: TileMap = get_node("../Walls")

var _cells: Array


func _ready():
	# Set tiles
	var floor_cells = _floor.get_used_cells()
	for wall in _walls.get_used_cells():
		floor_cells.erase(wall)
	_cells = floor_cells


func find_path(from: Vector2, to: Vector2) -> PoolVector2Array:
	var f = ((from - HALF_CELL) / CELL_SIZE).floor()
	var t = ((to - HALF_CELL) / CELL_SIZE).floor()
	return _find_path(f, t)


func _find_path(from: Vector2, to: Vector2) -> PoolVector2Array:
	# G movement cost, H distance left, point
	var open_list = [_new_point(0, from, to, from)]
	# Keeps track of visited points
	var closed_list = []
	var found = false
	var cell
	var attemps = 0
	while !open_list.empty() and !found and attemps < MAX_TRIES:
		# Pick closest tile to check
		cell = open_list[0]
		for c in open_list:
			if _point_cheaper(c, cell):
				cell = c
		# Move current tile to closed list
		open_list.erase(cell)
		var cell_pos = _point_position(cell)
		closed_list.push_back(_new_closed_point(cell_pos, cell[3]))
		#print(cell_pos, cell[3], attemps)
		# Find all adjacent tiles
		var adjacent_cells = [
			# adjacent point, is diagonal
			[Vector2(-1, -1), 1],
			[Vector2(0, -1), 0],
			[Vector2(1, -1), 1],
			[Vector2(-1, 0), 0],
			[Vector2(1, 0), 0],
			[Vector2(-1, 1), 1],
			[Vector2(0, 1), 0],
			[Vector2(1, 1), 1],
		]
		# Calculate new movement costs for orthogonal and diagonal
		var f = _f_cost(cell)
		var costs = [f + 10, f + 14]
		for adj in adjacent_cells:
			var adj_point = cell_pos + adj[0]
			if _valid_point(adj_point, closed_list):
				# Check if found path
				if adj_point == to:
					closed_list.push_back(_new_closed_point(adj_point, cell_pos))
					found = true
					break
				var new_cell = _new_point(costs[adj[1]], adj_point, to, cell_pos)
				var new_f = _f_cost(new_cell)
				# Replace if better
				var replaced = false
				for c in range(len(open_list)):
					if _point_better(new_cell, open_list[c]):
						#print(new_cell, ' better than ', open_list[c])
						open_list[c] = new_cell
						replaced = true
						break
				if not replaced:
					open_list.append(new_cell)
				# Check if the end has been reached
		attemps += 1
	# If path found, use end as best, otherwise use the best cell
	if !found:
		closed_list.append(_new_closed_point(_point_position(cell), cell[3]))
	var best = to if found else _point_position(cell)
	return _get_path(from, best, closed_list)


func _valid_point(point: Vector2, closed_list: Array) -> bool:
	if !_cells.has(point):
		return false
	for p in closed_list:
		if p[0] == point:
			return false
	return true


func _new_point(g: int, position: Vector2, to: Vector2, parent: Vector2) -> Array:
	return [g, _h(position, to), position, parent]


func _new_closed_point(position: Vector2, parent: Vector2) -> Array:
	return [position, parent]


func _point_cheaper(a: Array, b: Array) -> bool:
	return _f_cost(a) < _f_cost(b)


func _point_better(a: Array, b: Array) -> bool:
	# Check if positions match and is cheaper
	return a[2] == b[2] and _point_cheaper(a, b)


func _point_position(point: Array) -> Vector2:
	return point[2]


func _h(from: Vector2, to: Vector2) -> int:
	return int(abs(to.x - from.x) + abs(to.y - from.y)) * 10


func _f_cost(point: Array) -> int:
	return point[0] + point[1]


func _get_path(from: Vector2, to: Vector2, closed_list: Array) -> PoolVector2Array:
	var path = PoolVector2Array()
	var current: Vector2 = to
	while current != from:
		path.push_back((current * CELL_SIZE) + HALF_CELL)
		for point in closed_list:
			if point[0] == current:
				current = point[1]
				break
	path.invert()
	print(path)
	return path
