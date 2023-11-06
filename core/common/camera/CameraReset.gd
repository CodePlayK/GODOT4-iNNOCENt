extends Area2D

@onready var player_camera=%PlayerCamera
func _on_body_entered(body):
	player_camera.drag_vertical_offset=-1
	pass 
