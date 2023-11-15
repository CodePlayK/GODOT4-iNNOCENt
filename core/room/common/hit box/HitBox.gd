extends Component
##攻击盒
##
##可以被HurtBox检测到
class_name HitBox
##当前伤害盒是否启用
##伤害值
@export var damage:float
var strength:float
##伤害范围
var shape_list:Array[CollisionShape2D]
##接触后调用所有Node的.on_hurt()方法
@export var signal_node_list:Array[Node]
var real_node_list:Array

func on_master_ready(master) -> void:
	for node in get_children():
		if node is CollisionShape2D:
			shape_list.append(node)
	if owner is Player:
		#real_node_list = signal_node_list
		return
	if signal_node_list.is_empty():return
	for node in signal_node_list:
		NpcState.add_to_export_node_cache(owner,self,node)
	for node in signal_node_list:
		real_node_list.append(NpcState.get_export_node_cache(owner,self,node))	
		
func set_enable(flag:bool,index:int = -1):
	enable = flag
	if flag:
		enable_shape(index)
	else :
		disable_shape(index)
		
func disable_shape(index:int=-1):
	for i in shape_list.size():
		shape_list[i].set_deferred("disabled" , true)

func enable_shape(index:int=-1):
	for i in shape_list.size():
		if i == index or index == -1:
			shape_list[i].set_deferred("disabled" , false)

func _on_area_entered(area: Area2D) -> void:
	return
