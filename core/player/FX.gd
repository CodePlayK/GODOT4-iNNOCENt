extends Node2D
@onready var sword_wind: Area2D = $SwordWind

var fx_dic:Dictionary
@export_range(0,500) var length = 300.0
@export_range(0,5.0) var time = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fx_dic["SwordWind"] = [sword_wind,length,time]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func launch_obj(fx_name:String):
	var side:int=1
	if PlayerState.face_left:
		side=-1
	var fx_data =  fx_dic[fx_name]
	var obj:Area2D = fx_data[0].duplicate()
	#var material = fx_data[0].base.material.duplicate()
	#obj.base.material=material
	obj.scale.x = side*abs(obj.scale.x)
	add_child(obj)
	obj.set_enable(true)
	obj.show()
	var tween = obj.create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(obj,"global_position",Vector2(obj.global_position.x+fx_data[1]*side,obj.global_position.y),fx_data[2])
	await tween.finished
	tween.kill()
	obj.set_enable(false)
	obj.queue_free()
	
