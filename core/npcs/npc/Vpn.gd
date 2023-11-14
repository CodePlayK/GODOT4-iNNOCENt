extends Node
var direction_objs
var obj
func _ready() -> void:
	owner.ready.connect(on_obj_ready)

func on_obj_ready():
	obj = owner
	direction_objs =[
	owner.animation,
	]
	get_all_children(owner)
	
func get_all_children(node:Node):
	for child in node.get_children():
		if child.has_method("on_master_ready"):
			child.call("on_master_ready",self)
		if child:
			get_all_children(child)
