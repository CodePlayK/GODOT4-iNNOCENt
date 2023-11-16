@tool
extends Node2D
class_name Anime
@onready var master: Node = %Master
@export var animes:Array[AnimeConfig]
@export var base: AnimatedSprite2D
#@onready var base: AnimatedSprite2D = $base
@export var current_animation:String
@export var playing:bool = true:
	set(f):
		playing = f
		if !base:return
		if f:
			play_anime()
		else :
			pause_anime()
@export var current_frame:int = 0:
	set(i):
		current_frame = i
		if base:base.frame = i
@export var speed_scale:float = 1
@export var backward:bool = false
@export var loop:bool = false:
	set(f):
		loop = f
		if base:
			base.sprite_frames.set_animation_loop(current_animation,f)
@export var sound_config:Array[AnimeSoundConfig]
@export var hitbox_config:Array[AnimeHitBoxConfig]
@export var import_animated_sprite:bool = false:
	set(f):
		import_animated_sprite = f
		if f:
			import()
			
func _ready() -> void:
	connect_to_base(base)

func import():
	pass
	
func connect_to_base(base):
	base.frame_changed.connect(_on_base_frame_changed)

func play_anime():
	base.sprite_frames.set_animation_loop(current_animation,loop)
	var real_speed_scale:float=speed_scale
	if backward:real_speed_scale=-speed_scale
	base.play(current_animation,real_speed_scale,backward)

func stop_anime():
	base.stop()

func pause_anime():
	base.pause()

func _on_base_frame_changed() -> void:
	current_frame = base.get_frame()
	if master.obj.hit_box:
		for hc:AnimeHitBoxConfig in hitbox_config:
			if !backward:
				if hc.hit_start_frame == current_frame:
					master.obj.hit_box.set_enable(true,hc.collision_index)
				elif hc.hit_end_frame == current_frame:
					master.obj.hit_box.set_enable(false,hc.collision_index)
			else :
				if hc.hit_start_frame == current_frame:
					master.obj.hit_box.set_enable(false,hc.collision_index)
				elif hc.hit_end_frame == current_frame:
					master.obj.hit_box.set_enable(true,hc.collision_index)
	for se in sound_config:
		if !backward:
			if se.start_frame == current_frame:
				play_se(se)
			elif se.end_frame > se.start_frame and se.end_frame == current_frame:
				stop_sound(se)
		else :
			if se.start_frame == current_frame:
				stop_sound(se)
			elif se.end_frame > se.start_frame and se.end_frame == current_frame or (se.end_frame == 0 and current_frame == base.sprite_frames.get_frame_count(current_animation)-1) :
				play_se(se)
func play_se(sound_config:AnimeSoundConfig):
	EventBus._play_SE(sound_config.se_name,sound_config.se_speed,sound_config.se_pitch,str(get_instance_id()))

func stop_sound(sound_config:AnimeSoundConfig):
	EventBus._play_SE(sound_config.se_name,sound_config.se_speed,sound_config.se_pitch,str(get_instance_id()),false)		
