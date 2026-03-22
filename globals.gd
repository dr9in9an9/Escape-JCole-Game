extends CanvasLayer

var level: Level = null
@onready var anim_player = $AnimationPlayer

var can_move = false

const LEVEL = preload("uid://bnjch4oqqe6bs")

func _ready():
	start_game()

func start_game():
	level = LEVEL.instantiate()
	add_child(level)
	anim_player.play("fade_in")
	$AudioStreamPlayer.play(8)

func _on_animation_player_animation_finished(anim_name):
	can_move = true
