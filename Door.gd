extends StaticBody3D

@export var item = 0

func _on_area_2d_body_entered(body):
	Level.interact_popup = true
	Level.interact_object = self

func _on_area_2d_body_exited(body):
	Level.interact_popup = false
	Level.interact_object = null
