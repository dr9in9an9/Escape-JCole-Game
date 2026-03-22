extends Node3D

class_name Lure

var playing = false
var item = -1
@onready var stream = $AudioStreamPlayer3D
@export var jcole_offset: Vector3

func _on_area_3d_body_entered(body):
	if body == Globals.level.jcole:
		if playing == false:
			return
		body.disabling_lure = true
		$Timer.start()
		return
	
	if Globals.level.player.item != 1:
		return
	Globals.level.interact_popup = true
	Globals.level.interact_object = self

func _on_area_3d_body_exited(body):
	Globals.level.interact_popup = false
	Globals.level.interact_object = null

func on_interact():
	if playing:
		return
	playing = true
	stream.play(6.0)
	Globals.level.lure_is_playing = true
	Globals.level.lure_object = self
	Globals.level.player.item = -1
	Globals.level.lure_pos = Vector2i(floor(Globals.level.player.global_position.x), floor(Globals.level.player.global_position.z))

func _on_timer_timeout():
	stream.stop()
	$Timer2.start()

func get_dest():
	return Vector2i(floor(position.x) + jcole_offset.x, floor(position.z + jcole_offset.z) + jcole_offset.z)

func _on_timer_2_timeout():
	Globals.level.jcole.disabling_lure = false
	Globals.level.jcole.pathfind()
	Globals.level.lure_is_playing = false
	Globals.level.lure_object = null
