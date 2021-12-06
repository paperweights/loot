extends Node

var Point = preload("res://actors/pathing/point.gd")

onready var _floor: TileMap = get_node("../Floor")
onready var _walls: TileMap = get_node("../Walls")

var _cells: Array


func _ready():
	# Set tiles
	var floor_cells = _floor.get_used_cells()
	for wall in _walls.get_used_cells():
		floor_cells.erase(wall)
	_cells = floor_cells
	_find_path(Vector2(1, 2), Vector2(10, 12))


func _find_path(from: Vector2, to: Vector2) -> PoolVector2Array:
	var path = PoolVector2Array()
	# G movement cost, H distance left, point
	var open_list = [Point.new(0, from, to, null)]
	# Keeps track of visited points
	var closed_list = []
	var found = false
	while !open_list.empty() and !found:
		print(open_list)
		# Pick closest tile to check
		var cell: Point = open_list[0]
		for c in open_list:
			if c.cheaper(cell):
				cell = c
		# Move current tile to closed list
		open_list.erase(cell)
		closed_list.append(cell.get_position())
		# Find all adjacent tiles
		var adjacent_cells = [
			# adjacent point, is diagonal
			[cell[2] + Vector2(-1, -1), 1],
			[cell[2] + Vector2(0, -1), 0],
			[cell[2] + Vector2(1, -1), 1],
			[cell[2] + Vector2(-1, 0), 0],
			[cell[2] + Vector2(1, 0), 0],
			[cell[2] + Vector2(-1, 1), 1],
			[cell[2] + Vector2(0, 1), 0],
			[cell[2] + Vector2(1, 1), 1],
		]
		# Calculate new movement costs for orthogonal and diagonal
		var costs = [cell[0] + 10, cell[0] + 14]
		for adj in adjacent_cells:
			var adj_point = adj[0]
			if _cells.has(adj_point) and !closed_list.has(adj_point):
				# Check if the end has been reached
				if adj_point == to:
					found = true
					print('Found')
				var new_cell = [costs[adj[1]], _distance(adj_point, to), adj_point]
				var f_cost = _f_cost(new_cell)
				# Replace if better
				var replaced = false
				for c in range(len(open_list)):
					if open_list[c][2] == adj_point and f_cost < _f_cost(open_list[c]):
						open_list[c] = new_cell
						replaced = true
						break
				if not replaced:
					open_list.append(new_cell)
	return path





func _f_cost(cell: Array) -> int:
	return cell[0] + cell[1]
