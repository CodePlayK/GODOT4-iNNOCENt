extends Weight
@export var time_max:float
@export var time_min:float
var time
@onready var master: Node = %Master

func on_master_ready(m) -> void:
	obj = master.obj
	NpcState.add_to_export_node_cache(obj,self,target_state)
	target_state = NpcState.get_export_node_cache(obj,self,target_state)
	
func process() -> void:
	time = 4096 - obj.time_2_last_attack_timer.time_left
	var rmap = remap(time,time_min,time_max,impossible_weight,confirmed_weight)
	weight = clamp(rmap,confirmed_weight,impossible_weight)
	pass
