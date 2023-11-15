extends Node
##[必须挂载于obj根节点下/要求有名为「DialoguePosition」的Mark2d] 物体过场对话框，只负责显示，无状态
class_name CutsceneTalk
@onready var master: Node = %Master
var obj:PlayerInteractiveObj
var left_side_balloon:bool=false

func on_master_ready(master):
	obj = master.obj
	EventBus.cutscene_talk.connect(_talk)
	
func _talk(name:String,dialogue_resource:DialogueResource,title:String):
	if name!=obj.obj_name:return null
	obj.on_talk=true
	var flag = get_balloon_side()
	EventBus._talk(obj,dialogue_resource,title,obj.dialogue_position.global_position,flag,obj.obj_name)
	await DialogueManager.dialogue_ended
	obj.on_talk=false
	
func get_balloon_side():
	return obj.face_left
	
