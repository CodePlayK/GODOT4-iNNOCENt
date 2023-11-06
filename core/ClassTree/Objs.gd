class_name Objs extends PlayerInteractiveObj
@export var objs_name:String

func _ready() -> void:
	super._ready()

func _enter_tree() -> void:
	obj_name=objs_name
		
func enable_all_interact(flag):
	self.monitoring=flag
	self.monitorable=flag
	self.input_pickable=flag
