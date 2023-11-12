extends Area2D
##受伤盒
##
##用于探测是否被武器攻击,当有Area进入时,调用所有signal node list中每个node的on_hit()方法
class_name HurtBox
##接触后调用所有Node的.on_hit()方法
@export var signal_node_list:Array[Node]
var real_node_list:Array[Node]
##受伤的范围
@export var shape_list:Array[CollisionShape2D]
func _ready() -> void:
	if owner is Player:
		real_node_list = signal_node_list
		return
	if signal_node_list.is_empty():return
	for node in signal_node_list:
		NpcState.add_to_export_node_cache(owner,self,node)
	for node in signal_node_list:
		real_node_list.append(owner.get_node(NpcState.get_export_node_cache(owner,self,node)))
		
func _on_area_entered(area: Area2D) -> void:
	for node in real_node_list:
		node.on_hit(area)
##禁用
func disable_hit():
	for shape in shape_list:
		shape.disabled = true
##启用	
func enable_hit():
	for shape in shape_list:
		shape.disabled = false
