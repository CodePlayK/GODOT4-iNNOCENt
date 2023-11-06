extends Node
@onready var obj = $".."
@export var dialogue_resource:DialogueResource
@onready var dialogue_position = $"../DialoguePosition"
@export var on_left:bool=false
var current_line:String
#只能由鼠标悬浮可选中的物品，在不同场景下的默认对话，具体数据放在DialogueState里面配置
#要求有名为「DialoguePosition」的Mark2d
func _ready():
	obj.mouse_entered.connect(_ballon_on)
	obj.mouse_exited.connect(_ballon_off)
	DialogueState.dic_dialogue_position[obj.name]=dialogue_position.global_position
	EventBus.get_obj_position.connect(_get_obj_position)
	pass 
func _input(event):
	if obj.on_talk and event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		EventBus._next_dialogue()
func _ballon_on():
	obj.on_talk=true
	talk()
	pass
func _ballon_off():
	obj.on_talk=false
	EventBus._end_talk()
	pass
func talk():
	get_current_state_line()
	EventBus._talk(obj,dialogue_resource,current_line,dialogue_position.global_position,on_left,obj.name)
func get_current_state_line():
	current_line=DialogueState.get_current_cutscene_dialogue_line(obj.obj_name)
	
func _get_obj_position(obj_name):
	if obj_name!=obj.name:return null
	DialogueState.dic_dialogue_position[obj.name]=dialogue_position.global_position
	
	
