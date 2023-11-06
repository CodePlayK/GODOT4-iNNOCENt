extends Node
##[必须挂载于obj根节点下/要求有名为「DialoguePosition」的Mark2d] 物体过场对话框，只负责显示，无状态
class_name CutsceneTalk
@onready var obj = $".."
@onready var dialogue_position = $"../DialoguePosition"
@onready var base = $"../base"
var left_side_balloon:bool=false

func _ready():
	EventBus.cutscene_talk.connect(_talk)
	pass 
	
func _talk(name:String,dialogue_resource:DialogueResource,title:String):
	obj.on_talk=true
	var flag = get_balloon_side()
	if name!=obj.obj_name:return null
	EventBus._talk(obj,dialogue_resource,title,dialogue_position.global_position,flag,obj.obj_name)
	await DialogueManager.dialogue_ended
	obj.on_talk=false
func get_balloon_side():
	return obj.face_left
	
