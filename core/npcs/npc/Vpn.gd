extends Node
var direction_objs
@onready var obj: Area2D = $".."

func _ready() -> void:
	obj.ready.connect(on_obj_ready)

func on_obj_ready():
	obj = owner
	direction_objs =[
	obj.animation,
	]
	get_all_children(obj)
	
func get_all_children(node:Node):
	for child in node.get_children():
		if child.has_method("on_master_ready"):
			child.call("on_master_ready",self)
		if child:
			get_all_children(child)

func on_obj_health_change():
	pass
