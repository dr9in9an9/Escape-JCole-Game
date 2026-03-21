extends CharacterBody3D

@onready var camera = $Camera3D

var move_dir = Vector2.ZERO
var MOVE_SPEED = 3

var mouse_sensitivity = 0.001

var pitch = 0

var player_path: PackedVector2Array

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		camera.rotate_y(-event.relative.x * mouse_sensitivity)
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-80), deg_to_rad(80))
		camera.rotation.x = pitch

func _physics_process(delta):
	move_dir = Vector2.ZERO
	if Input.is_action_pressed("left"):
		move_dir.x = -1
	if Input.is_action_pressed("right"):
		move_dir.x = 1
	if Input.is_action_pressed("forward"):
		move_dir.y = 1
	if Input.is_action_pressed("backward"):
		move_dir.y = -1
	
	move_dir = move_dir.normalized()
	
	var forward = -camera.global_transform.basis.z
	var right = camera.global_transform.basis.x
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()
	
	var move_delta: Vector3
	if player_path.size() > 0:
		var top = player_path.get(0)
		while player_path.size() > 0 and top.distance_to(Vector2(position.x, position.z)) < 0.1:
			player_path.remove_at(0)
			top = player_path.get(0)
		move_delta = (Vector3(top.x, 0, top.y) - position)
		move_delta.y = 0
		move_delta = move_delta.normalized() * MOVE_SPEED
	else:
		move_delta = (right * move_dir.x + forward * move_dir.y).normalized() * MOVE_SPEED
	velocity = move_delta
	
	move_and_slide()
