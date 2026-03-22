extends StaticBody3D

@export var item = 0

# Items
# 0 - blue key
# 1 - battery
# 2 - red key
# 3 - green key

func _ready():
	var mat = $MeshInstance3D.get_active_material(0).duplicate()
	$MeshInstance3D.set_surface_override_material(0, mat)
	if item == 0:
		mat.albedo_texture = load("res://Textures/bluedoor.jpg")
	elif item == 2:
		mat.albedo_texture = load("res://Textures/red_Door.jpg")
	elif item == 3:
		mat.albedo_texture = load("res://Textures/greendoor.jpg")

func _on_area_2d_body_entered(body):
	Globals.level.interact_popup = true
	Globals.level.interact_object = self

func _on_area_2d_body_exited(body):
	Globals.level.interact_popup = false
	Globals.level.interact_object = null

func on_interact():
	Globals.level.interact_object.queue_free()
	for wall in Globals.level.get_node("Walls").get_children():
		if wall.name.begins_with("Door"):
			if wall.item == item:
				wall.queue_free()
	Globals.level.regenerate_path_mesh = true
	Globals.level.player.item = -1
	Globals.door_stream.play()
