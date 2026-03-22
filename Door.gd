extends StaticBody3D

@export var item = 0

# Items
# 0 - blue key
# 1 - battery
# 2 - red key
# 3 - green key

func _on_area_2d_body_entered(body):
	Globals.level.interact_popup = true
	Globals.level.interact_object = self

func _on_area_2d_body_exited(body):
	Globals.level.interact_popup = false
	Globals.level.interact_object = null

func on_interact():
	Globals.level.interact_object.queue_free()
	Globals.level.regenerate_path_mesh = true
	Globals.level.player.item = -1
