extends Component
##[Npcs]对象默认对话工具类
##
##[必须挂载于Npc对象根目录/要求有名为「DialoguePosition」的Mark2d] 只能由玩家接触选中的物体，在不同场景下的默认对话，具体数据放在DialogueState里面配置
class_name NpcDialogueDefault
var obj:PlayerInteractiveObj
##dialogue_resourced
@export var dialogue_resource:DialogueResource
var current_line:String
##对话框左右
@export var left_side_balloon:bool=false
@onready var master: Node = %Master

func init_var():
	clazz_name="NpcDialogueDefault"
	FATHER_CLASS_NAME="Npcs"
	
func on_master_ready(master):
	obj = master.obj
	DialogueState.dic_dialogue_position[obj.name]=obj.dialogue_position.global_position
	obj.body_entered.connect(_ballon_on)
	obj.body_exited.connect(_ballon_off)
	
func connect_signal():
	EventBus.get_obj_position.connect(_get_obj_position)
		
func _ballon_on(body):
	if CutsceneState.cutscener_playing:return
	obj.on_talk=true
	talk()
	
func _ballon_off(body):
	if CutsceneState.cutscener_playing:return
	obj.on_talk=false
	EventBus._end_talk()
	
func talk():
	get_current_state_line()
	get_balloon_side()
	EventBus._talk(obj,dialogue_resource,current_line,obj.dialogue_position.global_position,left_side_balloon,obj.name)

func get_current_state_line():
	current_line=DialogueState.get_current_cutscene_dialogue_line(obj.obj_name)
	
func get_balloon_side():
	if current_line.ends_with("L"):
		left_side_balloon=true
		current_line=current_line.substr(0,current_line.length()-1)
		return
	left_side_balloon = obj.face_left

func _get_obj_position(obj_name):
	if obj_name!=obj.name:return null
	DialogueState.dic_dialogue_position[obj.name]=obj.dialogue_position.global_position
	
