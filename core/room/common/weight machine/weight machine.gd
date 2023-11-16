extends Node
class_name WeightMachine
##总权重
var total_weight:float
@onready var master: Node = %Master
##目标归类总权重字典{目标1:权重合,目标2:权重合}
var weight_sum_dic:Dictionary 
##每一个目标state下的权重字典{目标1:[权重0,权重1],目标2:[权重0,权重1]}
var weight_dic:Dictionary 
##是否打印debug
@export var print_debug:bool = true
@onready var timer: Timer = $_Timer
##是否自动启用
@export var auto_run:bool = true:
	set(f):
		auto_run = f
		if !timer:return
		if f:
			timer.start(1)
		else:
			timer.stop()
##总权重上限
@export var total_weight_max:float = 100
##总权重下限
@export var total_weight_min:float = 10
var debug_dic:Dictionary

func _ready() -> void:
	for node in get_children():
		if node.name.begins_with("_"):continue
		weight_dic[node.name] = []
		weight_sum_dic[node.name] = 0
		for w_node in node.get_children():
			if w_node is Weight:
				weight_dic[node.name].append(w_node) 
		debug_dic[node.name]= 0
##分
func get_target_node_weight_sum():
	total_weight = 0
	for k in weight_dic.keys():
		weight_sum_dic[k] = 0
		for w in weight_dic[k]:
			await w.process()
			weight_sum_dic[k] = max(weight_sum_dic[k]+w.weight,0)
			total_weight+=weight_sum_dic[k]
		
func process():
	if weight_sum_dic.is_empty():return
	get_target_node_weight_sum()
	randomize()
	var weight_sum:float
	if total_weight <= 0:return null
	total_weight = clamp(total_weight,total_weight_min,total_weight_max)
	var fin_k:String
	var target = randf()*total_weight
	for k in weight_sum_dic.keys():
		var v = weight_sum_dic[k]
		weight_sum+=v
		if target<weight_sum:
			fin_k = k
			break
	if fin_k:
		debug_dic[fin_k]+=1
	if print_debug:
		Debug.dprintinfo("[%s][%s][%s]\n%s\n%s" %[total_weight,master.obj.obj_name,fin_k,debug_dic,weight_sum_dic])
	for k in weight_dic.keys():
		for w in weight_dic[k]:
			await w.after_process()
	return master.obj.states.get_state_by_name(fin_k)

func exit():
	for k in weight_dic.keys():
		for w in weight_dic[k]:
			await w.exit()

func _on_timer_timeout() -> void:
	process()
