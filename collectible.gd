extends Node3D

var rot_speed = PI
var just_spawned = false

@export var item = 0

func _ready():
	print(name)
	$Sprite3D.frame = item

func _physics_process(delta):
	rotation.y += rot_speed * delta

# Pickup
func _on_area_3d_body_entered(body):
	if just_spawned:
		just_spawned = false
		return
	if item == 5:
		Globals.acquire_mixtape()
		if Globals.mixtapes != 4:
			queue_free()
	else:
		body.pickup_item(item)
		queue_free()
