extends Area2D
@onready var base: AnimatedSprite2D = $base
@onready var sword_wind: CollisionShape2D = $SwordWind

var enable:bool = true
var damage:float = 10.0
func enables():
	sword_wind.disabled = false

func disable():
	sword_wind.disabled = true
