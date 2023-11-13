extends Node
@onready var obj: Area2D = $".."
var direction_objs

func _ready() -> void:
	obj.ready.connect(on_obj_ready)
	
func on_obj_ready():
	direction_objs =[
	obj.hurt_fx,
	obj.hit_box,
	obj.player_detection,
	obj.animation,
	]
	get_all_children(obj)
	
func get_all_children(node:Node):
	for child in node.get_children():
		for m_name in child.get_method_list():
			if m_name.name == "on_master_ready":
				child.call(m_name.name,self)
		if child:
			get_all_children(child)
