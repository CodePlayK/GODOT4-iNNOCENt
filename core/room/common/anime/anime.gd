@tool
@icon("res://core/room/common/anime/anime_icon.svg")
extends Node2D
class_name Anime
@onready var master: Node = %Master
@export_group("Anime基础设置")
@export var base: AnimatedSprite2D
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
@export var current_animation_length:float
@export_group("Debug")
@export var print_sound:bool = false
@export var print_fx:bool = false
@export var print_hitbox:bool = false

var anime_dic:Dictionary
var cache:Dictionary
var base_animation_name_array

func import():
	if animes:
		for anime_config in animes:
			anime_dic[anime_config.animation_name] = anime_config
	base_animation_name_array = base.sprite_frames.get_animation_names()
	
func play_anime(anime_name:String):
	if anime_name == "behitDamaged":
		pass
	var anime:AnimeConfig = anime_dic[anime_name]
	current_animation = anime_name
	current_animation_length = base.sprite_frames.get_frame_count(current_animation) / base.sprite_frames.get_animation_speed(current_animation) / anime.speed_scale
	base.sprite_frames.set_animation_loop(current_animation,anime.loop)
	base.speed_scale = anime.speed_scale
	preset_cache(anime)
	if !anime.backward:
		base.play(current_animation)
	else :
		base.play_backwards(current_animation)

func _physics_process(delta: float) -> void:
	if !anime_dic.has(current_animation):return
	var anime:AnimeConfig = anime_dic[current_animation]
	current_frame = base.get_frame()
	if master.obj.hit_box:
		set_hitbox(anime)	
	set_sound(anime)
	set_fx(anime)
	set_bati(anime)
				
func set_bati(anime:AnimeConfig):
	for bati_config:AnimeBatiConfig in anime.bati_config:
		if current_frame == bati_config.bati_start_frame:
			bati_config.bating = true
		elif current_frame == bati_config.bati_end_frame:
			bati_config.bating = false
func set_hitbox(anime):
	if master.obj.hit_box:
		for hc:AnimeHitBoxConfig in anime.hitbox_config:
			if !anime.backward:
				if hc.hit_start_frame == current_frame:
					if !check_cache(hc.collision_index+1):continue
					if print_hitbox:Debug.dprinterr("Anime设置hitbox[%s][%s]" %[current_animation,hc.collision_index])
					master.obj.hit_box.set_enable(true,hc.collision_index)
					cache_off(hc.collision_index+1)
				elif hc.hit_end_frame == current_frame:
					if !check_cache(hc.collision_index-1):continue
					if print_hitbox:Debug.dprinterr("Anime取消hitbox[%s][%s]" %[current_animation,hc.collision_index])
					master.obj.hit_box.set_enable(false,hc.collision_index)
					cache_off(hc.collision_index-1)
			else :
				if hc.hit_start_frame == current_frame:
					if !check_cache(hc.collision_index-1):continue
					master.obj.hit_box.set_enable(false,hc.collision_index)
					cache_off(hc.collision_index+1)
				elif hc.hit_end_frame == current_frame:
					if !check_cache(hc.collision_index-1):continue
					master.obj.hit_box.set_enable(true,hc.collision_index)
					cache_off(hc.collision_index-1)
func dis_all_hitbox(hitbox_config:AnimeHitBoxConfig):
	if print_hitbox:Debug.dprinterr("Anime禁用hitbox[%s][%s]" %[current_animation,hitbox_config.collision_index])
	master.obj.hit_box.set_enable(false,hitbox_config.collision_index)
func set_sound(anime:AnimeConfig):
	for se in anime.sound_config:
		if anime.animation_name == "behitDamaged":
			pass
		if !anime.backward:
			if se.start_frame == current_frame or !anime.has_animation:
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
			if print_fx:Debug.dprinterr("Anime发射FX[%s][%s]" %[current_animation,fx.launch_obj_name])
			master.obj.fx.launch_obj(fx.launch_obj_name)
			cache[fx.launch_obj_name] = false

func play_se(sound_config:AnimeSoundConfig):
	if check_cache(sound_config.sound_obj_prefix+sound_config.se_name) == false:return
	EventBus._play_SE(sound_config.se_name,sound_config.se_speed,sound_config.se_pitch,sound_config.sound_obj_prefix)
	if print_sound:Debug.dprinterr("Anime播放[%s][%s]" %[current_animation,sound_config.se_name])
	cache_off(sound_config.sound_obj_prefix+sound_config.se_name)
func stop_sound(sound_config:AnimeSoundConfig):
	EventBus._play_SE(sound_config.se_name,sound_config.se_speed,sound_config.se_pitch,sound_config.sound_obj_prefix,false)	
	if print_sound:Debug.dprinterr("Anime停止[%s][%s]" %[current_animation,sound_config.se_name])
	cache_off(sound_config.sound_obj_prefix+sound_config.se_name)		
	
#region cache
func preset_cache(anime:AnimeConfig):
	for fx in anime.fx_config:
		cache[fx.launch_obj_name] = true	
	for se in anime.sound_config:
		cache[se.sound_obj_prefix+se.se_name] = true	
	for ht in anime.hitbox_config:
		cache[ht.collision_index+1] = true	
		cache[ht.collision_index-1] = true	
func cache_on(key):
	cache[key] = true
func cache_off(key):
	cache[key] = false
func check_cache(key):
	if cache.has(key):return cache[key]
	cache[key] = true
	return cache[key]
#endregion
		
func stop_anime():
	base.stop()

func pause_anime():
	base.pause()
