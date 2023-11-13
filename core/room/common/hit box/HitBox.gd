extends Area2D
##攻击盒
##
##可以被HurtBox检测到
class_name HitBox
##当前伤害盒是否启用
var enable:bool = false
##伤害值
@export var damage:float
var strength:float
##伤害范围
var shape_list:Array[CollisionShape2D]

func _ready() -> void:
	for node in get_children():
		if node is CollisionShape2D:
			shape_list.append(node)
	
func set_enable(flag:bool,index:int = -1):
	enable = flag
	#if owner is Player:return
	if flag:
		enable_shape(index)
	else :
		disable_shape(index)
		
func disable_shape(index:int=-1):
	for i in shape_list.size():
		#if i == index:return
		shape_list[i].set_deferred("disabled" , true)

func enable_shape(index:int=-1):
	for i in shape_list.size():
		if i == index or index == -1:
			shape_list[i].set_deferred("disabled" , false)
