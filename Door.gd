extends StaticBody3D

@export var item = 0

func _on_area_2d_body_entered(body):
	Level.interact_popup = true
	Level.interact_object = self

func _on_area_2d_body_exited(body):
	Level.interact_popup = false
	Level.interact_object = null

func on_interact():
	Level.interact_object.queue_free()
	Level.regenerate_path_mesh = true
	Level.player.item = -1
