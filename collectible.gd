extends Node3D

var rot_speed = PI

var item = 0

func _ready():
	item = $Sprite3D.frame

func _physics_process(delta):
	rotation.y += rot_speed * delta

# Pickup
func _on_area_3d_body_entered(body):
	body.item = item
	queue_free()
