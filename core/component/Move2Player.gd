extends Component
##[必须挂载于npc对象下] 对象移动到玩家角色附近，并在途中与停止后面朝玩家
class_name Move2Player
@onready var base = $"../base"
@onready var obj = $".."
##停止移动的距离玩家距离
@export var distance:int
var left_side_balloon:bool=false
var temp_v:Vector2

func init_var():
	clazz_name="Move2Player"
	FATHER_CLASS_NAME="Npcs"
	
func connect_signal():
	EventBus.move_2_player.connect(_move_2_player)

func _move_2_player(name:String,time:float=1,distance_t:int = 0):
	if distance_t==0:distance_t = distance
	if name!=obj.obj_name:return null
	base.animation="walk"
	obj.enable_all_interact(false)
	if PlayerState.player_global_position<obj.global_position :
		EventBus._obj_set_face_left(obj.name,true)
	else :
		EventBus._obj_set_face_left(obj.name,false)
	if PlayerState.face_left:
		temp_v=Vector2(PlayerState.player_global_position.x-distance_t,PlayerState.player_global_position.y)
	else:
		temp_v=Vector2(PlayerState.player_global_position.x+distance_t,PlayerState.player_global_position.y)
	var	tween=obj.create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(obj,"global_position",temp_v,time)
	await tween.finished
	if PlayerState.face_left :
		EventBus._obj_set_face_left(obj.name,false)
	else :
		EventBus._obj_set_face_left(obj.name,true)
	obj.enable_all_interact(true)
	base.animation="idle"
	pass
