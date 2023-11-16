@tool
extends Node2D
class_name Anime
@onready var master: Node = %Master
var anime_dic:Dictionary
@export_group("Anime基础设置")
@export var base: AnimatedSprite2D
#@onready var base: AnimatedSprite2D = $base
@export var current_animation:String
@export var playing:bool = true:
	set(f):
		playing = f
		if !base:return
		if f:
			play_anime(current_animation)
		else :
			pause_anime()
@export var current_frame:int = 0
@export_group("Anime详细设置")
@export var animes:Array[AnimeConfig]
var cache:Dictionary

func import():
	if animes:
		for anime_config in animes:
			anime_dic[anime_config.animation_name] = anime_config

func play_anime(anime_name:String):
	var anime:AnimeConfig = anime_dic[anime_name]
	current_animation = anime_name
	base.sprite_frames.set_animation_loop(current_animation,anime.loop)
	var real_speed_scale:float=anime.speed_scale
	if anime.backward:real_speed_scale=-anime.speed_scale
	set_cache(anime)
	base.play(current_animation,real_speed_scale,anime.backward)
func stop_anime():
	base.stop()

func pause_anime():
	base.pause()

func _physics_process(delta: float) -> void:
	if !anime_dic.has(current_animation):return
	var anime:AnimeConfig = anime_dic[current_animation]
	current_frame = base.get_frame()
	if master.obj.hit_box:
		set_hitbox(anime)	
	set_sound(anime)
	set_fx(anime)
				
func play_se(sound_config:AnimeSoundConfig):
	if check_cache(sound_config.sound_obj_prefix) == false:return
	Debug.dprinterr(sound_config.sound_obj_prefix+"-"+sound_config.se_name)
	EventBus._play_SE(sound_config.se_name,sound_config.se_speed,sound_config.se_pitch,sound_config.sound_obj_prefix)
	cache[sound_config.sound_obj_prefix] = false
	
func stop_sound(sound_config:AnimeSoundConfig):
	EventBus._play_SE(sound_config.se_name,sound_config.se_speed,sound_config.se_pitch,sound_config.sound_obj_prefix,false)		
	cache[sound_config.sound_obj_prefix] = false

func set_hitbox(anime):
	if master.obj.hit_box:
		for hc:AnimeHitBoxConfig in anime.hitbox_config:
			if !anime.backward:
				if hc.hit_start_frame == current_frame:
					master.obj.hit_box.set_enable(true,hc.collision_index)
				elif hc.hit_end_frame == current_frame:
					master.obj.hit_box.set_enable(false,hc.collision_index)
			else :
				if hc.hit_start_frame == current_frame:
					master.obj.hit_box.set_enable(false,hc.collision_index)
				elif hc.hit_end_frame == current_frame:
					master.obj.hit_box.set_enable(true,hc.collision_index)
func set_sound(anime):
	for se in anime.sound_config:
		if !anime.backward:
			if se.start_frame == current_frame:
				play_se(se)
			elif se.end_frame > se.start_frame and se.end_frame == current_frame:
				stop_sound(se)
		else :
			if se.start_frame == current_frame:
				stop_sound(se)
			elif se.end_frame > se.start_frame and se.end_frame == current_frame or (se.end_frame == 0 and current_frame == base.sprite_frames.get_frame_count(current_animation)-1) :
				play_se(se)	
func set_fx(anime:AnimeConfig):
	if !master.obj.fx:return
	for fx in anime.fx_config:
		if !fx.launch_obj_name:continue
		if fx.start_frame == current_frame:
			if check_cache(fx.launch_obj_name) == false:continue
			master.obj.fx.launch_obj(fx.launch_obj_name)
			cache[fx.launch_obj_name] = false

func set_cache(anime):
	for fx in anime.fx_config:
		cache[fx.launch_obj_name] = true	
	for se in anime.sound_config:
		cache[se.sound_obj_prefix] = true	
func check_cache(key):
	if cache.has(key):return cache[key]
	cache[key] = true
	return cache[key]
