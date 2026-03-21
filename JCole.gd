extends CharacterBody3D

var path: PackedVector2Array

var MOVE_SPEED = 2

func _physics_process(delta):
	var move_delta: Vector3

	var forward = -$Sprite3D.global_transform.basis.z
	var right = $Sprite3D.global_transform.basis.x
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()

	if path.size() > 0:
		var top = path.get(0) + Vector2(0.5, 0.5)
		while path.size() > 0 and top.distance_to(Vector2(position.x, position.z)) < 0.1:
			path.remove_at(0)
			top = path.get(0) + Vector2(0.5, 0.5)
		move_delta = (Vector3(top.x, 0, top.y) - position)
		move_delta.y = 0
		move_delta = move_delta.normalized() * MOVE_SPEED
	
	velocity = move_delta
	move_and_slide()

func _on_timer_timeout():
	path.clear()
	path = Level.astar.get_point_path(Vector2i(position.x, position.z), Vector2i(Level.player.position.x, Level.player.position.z))
	#if (path.get(0) + Vector2(0.5, 0.5)).distance_to(Vector2i(position.x, position.z)) < 0.25:
	path.remove_at(0)
	path.remove_at(1)
	print(path.size())
