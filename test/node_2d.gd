extends Node2D
var obj_name = "test"
@onready var anime: Anime = $Anime
@export var run:bool
@onready var hit_box: HitBox = $HitBox
			
func play():
	anime.play_anime()

func _on_button_button_down() -> void:
	play()
	pass # Replace with function body.
