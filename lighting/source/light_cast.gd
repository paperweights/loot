class_name LightCast
extends RayCast2D

const RAY_COUNT = 360 / 4

onready var cast_points = _get_cast_points()


func _get_cast_points() -> PoolVector2Array:
	# calculate the directions of the points to raycast
	var increment = PI * 2 / RAY_COUNT
	var cast_points = PoolVector2Array()
	for i in range(RAY_COUNT):
		var angle = increment * i
		var new_point = Vector2(cos(angle), sin(angle))
		cast_points.push_back(new_point)
	return cast_points


func cast_points(length: float) -> PoolVector2Array:
	# get ray intersections in local space
	var results = PoolVector2Array()
	for i in range(RAY_COUNT):
		var target_point = cast_points[i] * length
		cast_to = target_point
		force_raycast_update()
		# calculate the new point
		var new_point = Vector2()
		if is_colliding():
			new_point = get_collision_point() - global_position
		else:
			new_point = target_point
		results.push_back(new_point)
	return results
