extends Node
@onready var obj: Node = $".."
var direction =[

]
func _ready() -> void:
	obj.ready.connect(on_obj_ready)
	
func on_obj_ready():
	get_all_children(obj)
	
func get_all_children(node:Node):
	for child in node.get_children():
		for m_name in child.get_method_list():
			if m_name.name == "on_master_ready":
				child.call(m_name.name,self)
		if child:
			get_all_children(child)
