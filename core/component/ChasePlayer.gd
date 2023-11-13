extends Node
##[必须挂载于obj根节点]让obj追踪玩家,并在距离小于等于diatance时停止追踪
class_name ChasePlayer
@onready var obj = $".."
##追踪停止距离
@export var distance:int
var left_side_balloon:bool=false
var temp_v:Vector2
var	tween

func _ready():
	EventBus.chase_player.connect(_chase_player)

func _chase_player(name:String,time:float=1):
	if name!=obj.name:return null
	obj.set_monitoring(false)
	obj.set_monitorable(false)
	if PlayerState.player_global_position.x<obj.global_position.x:
		EventBus._obj_set_face_left(obj.name,true)
		temp_v=Vector2(PlayerState.player_global_position.x+distance,PlayerState.player_global_position.y)
	else :
		EventBus._obj_set_face_left(obj.name,false)
		temp_v=Vector2(PlayerState.player_global_position.x-distance,PlayerState.player_global_position.y)
	tween=obj.create_tween()
	tween.tween_property(obj,"global_position",temp_v,time)
	await tween.finished
	obj.set_monitoring(true)
	obj.set_monitorable(true)
	pass
