extends CharacterBody3D
var direction = Vector3.ZERO

func _on_controls_direction_vector(dir):
	direction = dir
