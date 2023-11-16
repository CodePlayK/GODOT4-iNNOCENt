extends Resource
class_name AnimeConfig
@export_group("动画配置")
@export var animation_name:String = "NA"
@export var speed_scale:float = 1
@export var backward:bool = false
@export var loop:bool = false
@export_group("音效配置")
@export var sound_config:Array[AnimeSoundConfig]
@export_group("hitbox配置")
@export var hitbox_config:Array[AnimeHitBoxConfig]
@export_group("FX配置")
@export var fx_config:Array[AnimeFxConfig]
