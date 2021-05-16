extends RayCast2D

const RAY_COUNT = 360

onready var cast_points = _get_cast_points()


func _get_cast_points() -> PoolVector2Array:
	# Calculate the directions to cast.
	var cast_points = PoolVector2Array()
	var increment = PI * 2 / RAY_COUNT
	for i in range(RAY_COUNT):
		var angle = increment * i
		var new_point = Vector2(cos(angle), sin(angle))
		cast_points.push_back(new_point)
	update()
	return cast_points


func cast_points(length: float) -> PoolVector2Array:
	# Get ray intersections in local space.
	var results = PoolVector2Array()
	for i in range(RAY_COUNT):
		var target_point = cast_points[i] * length
		cast_to = target_point
		force_raycast_update()
		# Calculate the new point.
		var new_point = Vector2()
		if is_colliding():
			new_point = get_collision_point() - global_position
		else:
			new_point = target_point
		results.push_back(new_point)
	return results
