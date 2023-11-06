extends Node
@onready var obj = $".."

var current_scene_intract_time:int=0
var dic_scene_intract_time:Dictionary
#以不同场景分别统计当前物体与用户的交互次数(以触发interact为准)
func _ready() -> void:
	EventBus.add_interact_time.connect(_add_interact_time)

func _add_interact_time(obj_name):
	if obj_name!=obj.name: return null
	current_scene_intract_time+=1
	if !dic_scene_intract_time.has(CutsceneState.current_cutscene):
		dic_scene_intract_time[CutsceneState.current_cutscene]=0
	else:
		dic_scene_intract_time[CutsceneState.current_cutscene]+=1
