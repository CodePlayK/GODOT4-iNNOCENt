extends Resource
class_name WeightResource
@export var value:float:
	set(v):
		value = v
		real_weight = value * custom_weight_scale
@export var custom_weight_scale:float = 1.0
@export var real_weight:float = 1.0
@export var fuct:Callable
var obj:PlayerInteractiveObj

func get_weight():
	pass
