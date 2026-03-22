extends CharacterBody3D

var path: PackedVector2Array

@onready var visibility_ray = $RayCast3DVisbiility

var MOVE_SPEED = 2.5
var forward = Vector3(1, 0, 0)
var FOV = 60

func _physics_process(delta):
	var move_delta: Vector3
	
	var los = line_of_sight()
	
	if los:
		var to_player = Level.player.global_position - global_position
		to_player.y = 0
		to_player = to_player.normalized()
		forward = to_player
		move_delta = forward * MOVE_SPEED
	else:
		if path.size() > 0:
			var top = path.get(0) + Vector2(0.5, 0.5)
			while path.size() > 0 and top.distance_to(Vector2(position.x, position.z)) < 0.05:
				path.remove_at(0)
				top = path.get(0) + Vector2(0.5, 0.5)
			move_delta = (Vector3(top.x, 0, top.y) - position)
			move_delta.y = 0
			forward = move_delta.normalized()
			move_delta = move_delta.normalized() * MOVE_SPEED
		#Level.debug_path_sprite.global_position = Vector3(path.get(0).x + 0.5, 0.5, path.get(0).y)
	velocity = move_delta
	move_and_slide()

func line_of_sight() -> bool:
	visibility_ray.target_position = to_local(Level.player.global_position)
	visibility_ray.force_raycast_update()
	if visibility_ray.is_colliding():
		if visibility_ray.get_collider() == Level.player:
			return true
	return false

func _on_timer_timeout():
	path.clear()
	
	path = Level.astar.get_point_path(Vector2i(floor(position.x), floor(position.z)), Vector2i(floor(Level.player.position.x), floor(Level.player.position.z)))
	#if (path.get(0) + Vector2(0.5, 0.5)).distance_to(Vector2i(position.x, position.z)) < 0.25:
	print(path.size())
	if path.size() > 1:
		path.remove_at(0)
	if path.size() > 1:
		path.remove_at(0)
	print(path.size())
