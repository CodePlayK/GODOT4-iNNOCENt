extends Node2D
@onready var base: AnimatedSprite2D = $base

func play_fx(fx_name:String,hit_sound_name:String):
	EventBus._play_SE(hit_sound_name)
	base.frame = 0
	base.play(fx_name)
