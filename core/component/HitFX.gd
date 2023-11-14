extends Node2D
@onready var base: AnimatedSprite2D = $base

func play_fx(fx_name:String,hit_sound_name:String="NA",speed=1.0,effect_volume=0.0):
	if hit_sound_name!="NA":
		EventBus._play_SE(hit_sound_name,speed,effect_volume,str(owner.get_instance_id()))
	base.frame = 0
	base.play(fx_name)
