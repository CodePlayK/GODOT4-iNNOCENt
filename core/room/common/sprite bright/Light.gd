extends Area2D
##[必须挂载于Player根节点] Player专有灯光亮度控制
@onready var obj = $".."
@export_range(1.0,50) var max_bright = 7.0
@export_range(0.0,5) var min_bright = 0.0
@export_range(0,5.0) var trans_time = .2 
@onready var light: Area2D = $"."
var last_state:bool=false
var last_bright:float=1.0
var bright:float:
	set(f):
		bright = f
		obj.base.material.set_shader_parameter("mix_modulate_strength",f*max_bright)
		
func _ready() -> void:
	obj.ready.connect(init)


func init():
	bright = min_bright

func _process(delta: float) -> void:
	if light.has_overlapping_areas() and (!last_state or light.get_overlapping_areas()[0].bright!=last_bright):
		last_bright=light.get_overlapping_areas()[0].bright
		last_state=true
		change_bright(last_bright)
	elif !light.has_overlapping_areas() and last_state:
		change_bright(min_bright)	
		last_state=false	

func change_bright(bright1:float):
	bright = bright1
	return
	var tween = obj.base.create_tween()
	tween.tween_property(self,"bright",bright1,trans_time)
	await tween.finished
	tween.kill()
