extends Component
##接触后调用所有Node的.on_hurt()方法
@export var signal_node_list:Array[Node]
var real_node_list:Array[Node]
##受伤的范围
@export var shape_list:Array[CollisionShape2D]
var obj

func on_master_ready(master) -> void:
	if master.obj is Player:
		real_node_list = signal_node_list
		return
	obj=master.obj
	if signal_node_list.is_empty():return
	for node in signal_node_list:
		NpcState.add_to_export_node_cache(owner,self,node)
	for node in signal_node_list:
		real_node_list.append(NpcState.get_export_node_cache(owner,self,node))

func _on_area_entered(area: Area2D) -> void:
	for node in real_node_list:
		node.on_dodge(area)
##禁用
func disable_hit():
	enable = false
	for shape in shape_list:
		shape.disabled = true
##启用	
func enable_hit():
	enable = true
	for shape in shape_list:
		shape.disabled = false
