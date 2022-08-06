class_name DungeonRoom
extends Node2D

"""
conncections order: UP, LEFT, DOWN, RIGHT
connections:
	-1: Nothing, when connecting between cells in a room
	0: Solid wall
	1: Exit
	2: Empty corridor
	3: Door
"""
export(Dictionary) var cells = {
	Vector2(): {
		'connections': PoolIntArray([2, 2, 2, 2])
	}
}
