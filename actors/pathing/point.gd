class_name Point

var _g: int
var _h: int
var _f: int
var _position: Vector2
var _parent: Vector2

func _init(g: int, position: Vector2, to: Vector2, parent: Vector2):
	self._g = g
	_set_h(position, to)
	_update_f()
	self._position = position
	self._parent = parent

func get_position() -> Vector2:
	return self._position

func _set_h(from: Vector2, to: Vector2):
	self._h = int(abs(to.x - from.x) + abs(to.y - from.y)) * 10

func _update_f():
	self._f = self._g + self._h

func cheaper(other: Point) -> bool:
	return self._f < other._f
