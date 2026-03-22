extends CharacterBody3D

var path: PackedVector2Array

@onready var visibility_ray = $RayCast3DVisbiility
@onready var ray_left = $RayCast3DLeft
@onready var ray_right = $RayCast3DRight
@onready var footstep_stream = $FootstepStream
@onready var music_stream = $MusicStream

const J_COLE_MUSIC_1_EAR_RAPE = preload("uid://co0rxjg8cdbws")
const J_COLE_MUSIC_2_EAR_RAPE = preload("uid://n6i80oy2bitm")

var MOVE_SPEED = 4
var forward = Vector3(1, 0, 0)
var FOV = 60
var los_last_frame = false
var clear_path_last_frame = false
var disabling_lure = false

func _physics_process(delta):
	var move_delta: Vector3
	
	var los = line_of_sight()
	var clear_path = false
	
	if disabling_lure or Globals.losing:
		$AnimationPlayer.stop()
		return
	
	
	if Globals.level.lure_is_playing:
		los = false
		clear_path = false
		MOVE_SPEED = 7
	else:
		if los:
			if music_stream.playing == false:
				random_music()
			clear_path = clear_path()
			los_last_frame = true
			MOVE_SPEED = 4
		else:
			if los_last_frame:
				$LOSTimer.start()
				los_last_frame = false
		
		if clear_path:
			MOVE_SPEED = 5
			# Go directly toward player if possible
			clear_path_last_frame = true
			var to_player = Globals.level.player.global_position - global_position
			to_player.y = 0
			to_player = to_player.normalized()
			forward = to_player
			move_delta = forward * MOVE_SPEED
		elif clear_path_last_frame:
			pathfind()
			clear_path_last_frame = false
	
	if clear_path == false:
		if path.size() == 0:
			pathfind()
		if path.size() > 0:
			var top = path.get(0) + Vector2(0.5, 0.5)
			if path.size() > 0 and top.distance_to(Vector2(global_position.x, global_position.z)) < 0.05:
				path.remove_at(0)
				top = path.get(0) + Vector2(0.5, 0.5)
			move_delta = (Vector3(top.x, 0, top.y) - position)
			move_delta.y = 0
			forward = move_delta.normalized()
			move_delta = move_delta.normalized() * MOVE_SPEED
	velocity = move_delta
	if move_delta != Vector3.ZERO and $AnimationPlayer.is_playing() == false:
		$AnimationPlayer.play("Run")
	move_and_slide()

func random_music():
	var randnum = (randi() % 2)
	if randnum == 0:
		music_stream.stream = J_COLE_MUSIC_2_EAR_RAPE
		if randi() % 2 == 0:
			music_stream.play(76.32)
		else:
			music_stream.play(18.5)
	else:
		music_stream.stream = J_COLE_MUSIC_1_EAR_RAPE
		if randi() % 2 == 0:
			music_stream.play(138.32)
		else:
			music_stream.play(17.8)

func line_of_sight() -> bool:
	visibility_ray.target_position = to_local(Globals.level.player.global_position)
	visibility_ray.force_raycast_update()
	if visibility_ray.is_colliding():
		if visibility_ray.get_collider() == Globals.level.player:
			return true
	return false

func clear_path() -> bool:
	ray_left.target_position = ray_left.to_local(Globals.level.player.global_position)
	ray_left.force_raycast_update()
	if ray_left.is_colliding():
		if ray_left.get_collider() != Globals.level.player:
			return false
	else:
		return false
	ray_right.target_position = ray_right.to_local(Globals.level.player.global_position)
	ray_right.force_raycast_update()
	if ray_right.is_colliding():
		if ray_right.get_collider() != Globals.level.player:
			return false
	else:
		return false
	return true


func pathfind():
	path.clear()
	var dest: Vector2i
	if Globals.level.lure_is_playing:
		dest = Globals.level.lure_object.get_dest()
	else:
		dest = Vector2i(floor(Globals.level.player.position.x), floor(Globals.level.player.position.z))
	path = Globals.level.astar.get_point_path(Vector2i(floor(position.x), floor(position.z)), dest)


func _on_area_3d_body_entered(body):
	Globals.can_move = false
	$DeathStream.play()
	music_stream.stop()
	Globals.losing = true
	$FootstepStream.stop()

func _on_death_stream_finished():
	Globals.lose_game()

func _on_los_timer_timeout():
	music_stream.stop()
	MOVE_SPEED = 2.5
