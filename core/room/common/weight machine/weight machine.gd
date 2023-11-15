extends Node
var total_weight:float
@onready var master: Node = %Master
@export var weight_list:Array[WeightResource] 
@export var print_debug:bool = true
@export var total_weight_max:float = 100
var debug_list:Array

func _ready() -> void:
	for w in weight_list:
		debug_list.append(0)

func process() -> void:
	if weight_list.is_empty():return
	randomize()
	total_weight=0
	var weight_sum:float
	for w in weight_list:
		if !w:continue
		total_weight+=w.value * w.custom_weight_scale
	clamp(total_weight,total_weight,total_weight_max)
	var fin_i:int
	var target = randf()*total_weight
	for i in weight_list.size():
		var v = weight_list[i].value * weight_list[i].custom_weight_scale
		weight_sum+=v
		if target<weight_sum:
			fin_i = i
			break
	debug_list[fin_i]+=1
	if print_debug:
		Debug.dprintinfo("[%s]:%s%s" %[master.obj.obj_name,weight_list[fin_i].value,debug_list])
	#print("%s[%s]%s" %[target,fin_i,weight_list[fin_i].weight])

func _on_timer_timeout() -> void:
	process()
