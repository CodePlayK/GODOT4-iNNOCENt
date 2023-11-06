extends Component
class_name FaceDirection
@onready var obj = $".."
@onready var base = $"../base"
@onready var dialogue_position = $"../DialoguePosition"
@onready var player_detection: Area2D = $"../PlayerDetection"
@onready var weapon: Area2D = $"../Weapon"
var base_scale
#控制对象的面朝方向
#要求必须有dialogue_position节点

func init_var():
	clazz_name="FaceDirection"
	FATHER_CLASS_NAME="Npcs"
	
func load_var():
	base_scale=abs(base.scale.x)

func connect_signal():
	EventBus.obj_set_face_left.connect(_obj_set_face_left)
	
func _obj_set_face_left(name,left_flag:bool=false):
	if name!=obj.name: return null
	if left_flag:
		base.scale.x=-1*base_scale
		dialogue_position.position.x=-abs(dialogue_position.position.x)
		player_detection.scale.x=-1
		weapon.set_scale(Vector2(-1,1))
		obj.face_left = true
	else:
		base.scale.x=base_scale
		dialogue_position.position.x=abs(dialogue_position.position.x)
		player_detection.scale.x=1
		weapon.set_scale(Vector2(1,1))
		obj.face_left = false
