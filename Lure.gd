extends Node3D

class_name Lure

var playing = false
var item = -1
@onready var stream = $AudioStreamPlayer3D

func _on_area_3d_body_entered(body):
	if body == Level.jcole:
		if playing == false:
			return
		body.disabling_lure = true
		$Timer.start()
		return
	
	if Level.player.item != 1:
		return
	Level.interact_popup = true
	Level.interact_object = self

func _on_area_3d_body_exited(body):
	Level.interact_popup = false
	Level.interact_object = null

func on_interact():
	if playing:
		return
	playing = true
	stream.play()
	Level.lure_is_playing = true
	Level.lure_object = self
	Level.player.item = -1

func _on_timer_timeout():
	stream.stop()
	$Timer2.start()

func _on_timer_2_timeout():
	Level.jcole.disabling_lure = false
	Level.jcole.pathfind()
	Level.lure_is_playing = false
	Level.lure_object = null
