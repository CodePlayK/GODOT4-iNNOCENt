extends Node2D
@onready var base: AnimatedSprite2D = $base

func play_fx(fx_name:String):
	base.frame = 0
	base.play(fx_name)
