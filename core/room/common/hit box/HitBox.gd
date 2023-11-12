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
	
func set_enable(flag:bool):
	enable = flag
	#if owner is Player:return
	if flag:
		enable_shape()
	else :
		disable_shape()
		
func disable_shape():
	for shape in shape_list:
		shape.set_deferred("disabled" , true)

func enable_shape():
	for shape in shape_list:
		shape.set_deferred("disabled" , false)
