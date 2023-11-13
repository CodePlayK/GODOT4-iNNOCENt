extends Component
##[必须挂载于npc对象下] 对象移动到玩家角色附近，并在途中与停止后面朝玩家
class_name Move2Vec2
@onready var obj = $".."
##停止移动的距离玩家距离
@export var distance:int
var left_side_balloon:bool=false
var temp_v:Vector2

func init_var():
	clazz_name="Move2Vec2"
	FATHER_CLASS_NAME="Npcs"
	
func connect_signal():
	EventBus.move_2_vec2.connect(_move_2_vec2)

func _move_2_vec2(name:String,pos:Vector2,time:float=1):
	if name!=obj.obj_name:return null
	obj.aniplayer.play("walk")
	obj.enable_all_interact(false)
	if pos<obj.global_position :
		EventBus._obj_set_face_left(obj.name,true)
	else :
		EventBus._obj_set_face_left(obj.name,false)
	if PlayerState.face_left:
		temp_v=Vector2(pos.x-distance,obj.global_position.y)
	else:
		temp_v=Vector2(pos.x+distance,obj.global_position.y)
	var	tween=obj.create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(obj,"global_position",temp_v,time)
	await tween.finished
	obj.enable_all_interact(true)
	obj.aniplayer.play("idle")
	pass
