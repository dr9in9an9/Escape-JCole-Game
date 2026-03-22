extends Control

var play_pressed = false
@onready var stream = $AudioStreamPlayer2D

func _on_play_button_pressed():
	if play_pressed:
		return
	play_pressed = true
	$AnimationPlayer.play("play")

func _on_quit_button_pressed():
	if play_pressed:
		return
	get_tree().quit()

func _on_animation_player_animation_finished(anim_name):
	stream.play()

func _on_audio_stream_player_2d_finished():
	queue_free()
	Globals.start_game()
