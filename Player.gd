extends CharacterBody3D

@onready var camera = $Camera3D

var move_dir = Vector2.ZERO
var MOVE_SPEED = 3

var mouse_sensitivity = 0.001

var pitch = 0

var menu_open = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event.is_action_pressed("menu"):
		if !menu_open:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if menu_open:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		menu_open = not menu_open

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if !menu_open:
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
	var move_delta = (right * move_dir.x + forward * move_dir.y).normalized() * MOVE_SPEED
	velocity = move_delta
	
	move_and_slide()
