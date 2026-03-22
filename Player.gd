extends CharacterBody3D

@onready var camera = $Camera3D
@onready var fists = $CanvasLayer/Sprite2D

const COLLECTIBLE = preload("uid://h6qpublu1ms1")

var move_dir = Vector2.ZERO
var MOVE_SPEED = 3

var mouse_sensitivity = 0.001

var pitch = 0

var menu_open = false

var item = -1

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$CanvasLayer/Sprite2D.frame = 4

func _input(event):
	if Globals.can_move == false:
		return
	if event.is_action_pressed("menu"):
		if !menu_open:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if menu_open:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		menu_open = not menu_open

func _unhandled_input(event):
	if Globals.can_move == false:
		return
	if event is InputEventMouseMotion:
		if !menu_open:
			camera.rotate_y(-event.relative.x * mouse_sensitivity)
			pitch -= event.relative.y * mouse_sensitivity
			pitch = clamp(pitch, deg_to_rad(-80), deg_to_rad(80))
			camera.rotation.x = pitch

func _physics_process(delta):
	if Globals.can_move == false:
		return
	
	move_dir = Vector2.ZERO
	if Input.is_action_pressed("left"):
		move_dir.x = -1
	if Input.is_action_pressed("right"):
		move_dir.x = 1
	if Input.is_action_pressed("forward"):
		move_dir.y = 1
	if Input.is_action_pressed("backward"):
		move_dir.y = -1
	
	if Input.is_action_just_pressed("interact"):
		if Globals.level.interact_popup:
			if Globals.level.interact_object:
				if Globals.level.interact_object.item == -1 || Globals.level.interact_object.item == item:
					Globals.level.interact_object.on_interact()
					Globals.level.interact_popup = false
					Globals.level.interact_object = null
	
	if Input.is_action_pressed("Debugfly"):
		camera.position.y += 6 * delta
	
	move_dir = move_dir.normalized()
	
	var forward = -camera.global_transform.basis.z
	var right = camera.global_transform.basis.x
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()
	
	var move_delta: Vector3
	#if player_path.size() > 0:
		#var top = player_path.get(0)
		#while player_path.size() > 0 and top.distance_to(Vector2(position.x, position.z)) < 0.1:
			#player_path.remove_at(0)
			#top = player_path.get(0)
		#move_delta = (Vector3(top.x, 0, top.y) - position)
		#move_delta.y = 0
		#move_delta = move_delta.normalized() * MOVE_SPEED
	#else:
	move_delta = (right * move_dir.x + forward * move_dir.y).normalized() * MOVE_SPEED
	velocity = move_delta
	
	move_and_slide()
	
	if item == -1:
		fists.visible = false
	else:
		fists.visible = true
		fists.frame = item
		print("Fists")

func pickup_item(new_item):
	if item != -1:
		var inst = COLLECTIBLE.instantiate()
		inst.global_position = Vector3(floor(global_position.x + 0.5), 0, floor(global_position.z + 0.5))
		inst.item = item
		inst.just_spawned = true
		Globals.level.add_child(inst)
	
	item = new_item
