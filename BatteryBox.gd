extends Node3D

var playing = false
var item = -1
@onready var stream = $AudioStreamPlayer3D

func _on_area_3d_body_entered(body):
	Level.interact_popup = true
	Level.interact_object = self

func _on_area_3d_body_exited(body):
	Level.interact_popup = false
	Level.interact_object = null

func on_interact():
	if Level.player.item == 1:
		return
	Level.player.pickup_item(1)
