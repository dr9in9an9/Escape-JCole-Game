extends Node3D

var rot_speed = PI

func _physics_process(delta):
	rotation.y += rot_speed * delta


# Pickup
func _on_area_3d_body_entered(body):
	queue_free()
