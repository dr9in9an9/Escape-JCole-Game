extends CanvasLayer

var level: Level = null
@onready var anim_player = $AnimationPlayer
@onready var mixtape_label = $CanvasLayer/MixtapeLabel
@onready var sprite_f = $CanvasLayer/SpriteF
@onready var door_stream = $AudioStreamPlayer2

var can_move = false
var losing = false

const WIN_SCREEN = preload("uid://b4isc62uiyfn1")
const LEVEL = preload("uid://bnjch4oqqe6bs")
const LOSE_SCREEN = preload("uid://crvais1yqrqx3")

var mixtapes = 0

func acquire_mixtape():
	mixtapes += 1
	mixtape_label.text = str(mixtapes) + "/4"
	if mixtapes == 4:
		win_game()

func _ready():
	losing = false
	mixtapes = 0

func start_game():
	losing = false
	mixtapes = 0
	level = LEVEL.instantiate()
	add_child(level)
	$AudioStreamPlayer.play(8)
	$CanvasLayer.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	can_move = true

func win_game():
	$CanvasLayer.visible = false
	level.free()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	add_child(WIN_SCREEN.instantiate())
	$AudioStreamPlayer.stop()

func lose_game():
	$CanvasLayer.visible = false
	level.queue_free()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	add_child(LOSE_SCREEN.instantiate())
	$AudioStreamPlayer.stop()

func _on_animation_player_animation_finished(anim_name):
	can_move = true

func _physics_process(delta):
	if level != null:
		if level.interact_object != null and level.interact_popup:
			sprite_f.visible = true
		else:
			sprite_f.visible = false
