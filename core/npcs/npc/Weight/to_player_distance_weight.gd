extends Weight
@export var distance_max:float
@export var distance_min:float
var distance
@onready var master: Node = %Master

func on_master_ready(m) -> void:
	obj = master.obj
	NpcState.add_to_export_node_cache(obj,self,target_state)
	target_state = NpcState.get_export_node_cache(obj,self,target_state)
	
func process() -> void:
	distance = abs(obj.global_position.x - PlayerState.player.global_position.x)
	weight = clamp(remap(distance,distance_min,distance_max,confirmed_weight,impossible_weight),impossible_weight,confirmed_weight)
