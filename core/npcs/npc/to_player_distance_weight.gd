extends Weight
@export var weight:WeightResource
@export var obj:PlayerInteractiveObj
@export var target_state:NpcsBaseState
@export var distance_max:float
@export var distance_min:float
@export var distance_max_map:float
@export var distance_min_map:float
var distance
func _process(delta: float) -> void:
	distance = abs(obj.global_position.x - PlayerState.player.global_position.x)
	weight.value = clamp(remap(distance,distance_min,distance_max,distance_max_map,distance_min_map),distance_min_map,distance_max_map)
