extends Component
class_name FaceDirection
@onready var obj = $".."
@onready var base = $"../base"
@onready var dialogue_position = $"../DialoguePosition"
@onready var player_detection: Area2D = $"../PlayerDetection"
@onready var hit_box: Area2D = $"../HitBox"
@onready var hit_fx: Node2D = $"../HitFX"
var node_list:Array[Node2D]
#控制对象的面朝方向
#要求必须有dialogue_position节点

func init_var():
	clazz_name="FaceDirection"
	FATHER_CLASS_NAME="Npcs"

func connect_signal():
	EventBus.obj_set_face_left.connect(_obj_set_face_left)
	
func _obj_set_face_left(name,left_flag:bool=false):
	if name!=obj.name: return null
	node_list=[hit_fx,hit_box,player_detection,base]
	for node in node_list:
		if !node:continue
		if left_flag:
			node.scale.x=-1*abs(node.scale.x)
		else :
			node.scale.x=abs(node.scale.x)
	if left_flag:
		dialogue_position.position.x=-abs(dialogue_position.position.x)
	else :
		dialogue_position.position.x=abs(dialogue_position.position.x)
	obj.face_left = left_flag
