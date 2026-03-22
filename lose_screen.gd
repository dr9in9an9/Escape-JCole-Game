extends Control

func _on_play_button_pressed():
	queue_free()
	Globals.start_game()
