@tool
@icon("res://core/resource/icon/ProgressBar.png")
extends Control
class_name UIbar
@export_category("状态条配置")
@export_group("初始化设置")
@export var bar_max_value:float:
	set(f):
		bar_max_value = f
		if ui_bar:ui_bar.max_value = f
		if back_bar:back_bar.max_value = f
@export var bar_min_value:float = 0:
	set(f):
		bar_min_value = f
		if ui_bar:ui_bar.min_value = f
		if back_bar:back_bar.min_value = f
@export var back_bar_enable:bool = true:
	set(f):
		back_bar_enable = f
		preset_back_bar(back_bar_enable)
@export var current_value:float:
	set(v):
		last_value = current_value
		current_value = v
@export_group("外观")
@export var back_bar_delay_time:float
@export var bar_animation_time:float = .2
@export var back_bar_animation_time:float = .2
@export var bar_color:Color = "00ff00ef":
	set(c):
		bar_color = c
		set_color()
@export var back_bar_color:Color = "ff00007b":
	set(c):
		back_bar_color = c
		set_color()
var last_value:float
@onready var back_bar_timer: Timer = $BackBarTimer
@onready var back_bar: ProgressBar = $UIBarBack
@onready var ui_bar: ProgressBar = $UIBar

func _ready() -> void:
	preset_back_bar(back_bar_enable)
	set_color()

func bar_decrease(v):
	current_value = v
	if !ui_bar:return
	#Debug.dprintwarn("[max:%s][%s]->[%s]" %[bar_max_value,last_value,current_value])
	var bar_tween = ui_bar.create_tween() 
	bar_tween.set_trans(Tween.TRANS_CUBIC)
	bar_tween.set_ease(Tween.EASE_OUT)
	bar_tween.tween_property(ui_bar,"value",current_value,bar_animation_time)
	await bar_tween.finished
	bar_tween.kill()
	if back_bar_timer.is_stopped() and back_bar_enable:
		await get_tree().create_timer(back_bar_animation_time)
		back_bar.value = last_value
		back_bar_timer.start(back_bar_delay_time)

func _on_back_bar_timer_timeout() -> void:
	var back_bar_tween = back_bar.create_tween() 
	back_bar_tween.set_trans(Tween.TRANS_CUBIC)
	back_bar_tween.set_ease(Tween.EASE_OUT)
	back_bar_tween.tween_property(back_bar,"value",current_value,back_bar_animation_time)
	await back_bar_tween.finished
	back_bar_tween.kill()

func bar_grow(v):
	current_value = v
	if !ui_bar:return
	#Debug.dprintwarn("[max:%s][%s]->[%s]" %[bar_max_value,last_value,current_value])
	var bar_tween = ui_bar.create_tween() 
	bar_tween.set_trans(Tween.TRANS_CUBIC)
	bar_tween.set_ease(Tween.EASE_OUT)
	bar_tween.tween_property(ui_bar,"value",current_value,bar_animation_time)
	await bar_tween.finished
	bar_tween.kill()
func preset_back_bar(f):
	if !back_bar:return
	if f:
		back_bar.value = bar_max_value
	else :
		back_bar.value = bar_min_value
func set_color():
	#back_bar.modulate = back_bar_color
	if ui_bar:ui_bar.modulate = bar_color
