extends Node3D

class_name BatteryBox

var playing = false
var item = -1
@onready var stream = $AudioStreamPlayer3D

func _on_area_3d_body_entered(body):
	Globals.level.interact_popup = true
	Globals.level.interact_object = self

func _on_area_3d_body_exited(body):
	Globals.level.interact_popup = false
	Globals.level.interact_object = null

func on_interact():
	if Globals.level.player.item == 1:
		return
	Globals.level.player.pickup_item(1)
