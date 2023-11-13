extends Component
class_name FaceDirection
var node_list:Array
var obj
#控制对象的面朝方向
#要求必须有dialogue_position节点

func init_var():
	clazz_name="FaceDirection"
	FATHER_CLASS_NAME="Npcs"

func on_master_ready(master):
	obj = master.obj
	node_list = master.direction_objs

func connect_signal():
	EventBus.obj_set_face_left.connect(_obj_set_face_left)

func set_faced(left_flag:bool=false):
	_obj_set_face_left(obj.name,left_flag)
	
func _obj_set_face_left(name,left_flag:bool=false):
	if name!=obj.name: return null
	for node in node_list:
		if !node:continue
		if left_flag:
			node.scale.x=-1*abs(node.scale.x)
		else :
			node.scale.x=abs(node.scale.x)
	if left_flag:
		obj.dialogue_position.position.x=-abs(obj.dialogue_position.position.x)
	else :
		obj.dialogue_position.position.x=abs(obj.dialogue_position.position.x)
	obj.face_left = left_flag
