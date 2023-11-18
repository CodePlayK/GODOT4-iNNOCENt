##视差层
##
##根据玩家的移动有规则的移动此节点下的所有一级子节点[br]
##[color=yellow]注意:必须挂载于[Rooms]节点下![br]
##视差层速度配置必须与对应node名一致[/color][br]
##一般将[Player],[Npcs]等其他需要移动的节点放于同一个视差速度为[param 0]的layer下
class_name Parallax extends Component
#此节点下的第一代子节点会作为视差层
@onready var room = $".."
@export var parallax_main_layer:Node2D
@export_category("视差层速度配置")
@export var parallax_layer_speed_0:=-110
@export var parallax_layer_speed_1:=-80
@export var parallax_layer_speed_2:=-60
@export var parallax_layer_speed_2_5:=-40
@export var parallax_layer_speed_3:=-30
@export var parallax_layer_speed_4:=-20
@export var parallax_layer_speed_5:=0
@export var parallax_layer_speed_6:=20
@export var parallax_layer_speed_7:=200
##视差层表名
const TABLE_NAME="parallax"
##视差层sqlite日志打印级别
const VERBOSITY_LEVEL: int = SQLite.QUIET
##保存的条件语句
var CONDITION_SAVE
##视差层sqlite
var DB:SQLite
var parallax_layers:Array=[]
var parallax_layers_speed:Array[int]=[]
var player_last_position_x:float=0.0
var player_position_x:float=0
##当前帧所增加的距离
var add_position_x=0
var dic_position:Dictionary={}
##视差层的计算起点
@onready var parallax_start=%ParallaxStart
##视差层的每一层至今所移动的距离,储存于[Resource]中,可供其他node使用
var parallax_move_data

func init_var():
	FATHER_CLASS_NAME="Rooms"
	clazz_name="Parallax"
	
func ready():
	Global.current_main_layer = parallax_main_layer
	DB=SQLite.new()
	DB.path=Global.DB_NAME
	DB.verbosity_level = VERBOSITY_LEVEL
	parallax_move_data=preload(Global.parallax_move_data_source_path)
	EventBus.player_save_game.connect(_save_position)
	EventBus.load_game.connect(_load)
	EventBus.delete_save.connect(_delete_save)
	get_parallax_layers()
	player_last_position_x= parallax_start.global_position.x
	parallax_layers_speed.append(parallax_layer_speed_0)
	parallax_layers_speed.append(parallax_layer_speed_1)
	parallax_layers_speed.append(parallax_layer_speed_2)
	parallax_layers_speed.append(parallax_layer_speed_2_5)
	parallax_layers_speed.append(parallax_layer_speed_3)
	parallax_layers_speed.append(parallax_layer_speed_4)
	parallax_layers_speed.append(parallax_layer_speed_5)
	parallax_layers_speed.append(parallax_layer_speed_6)
	parallax_layers_speed.append(parallax_layer_speed_7)
	pass

func physics_process(delta: float):
	player_position_x=get_player_position_x()
	for i in range(0,parallax_layers.size()):
		on_parallax(parallax_layers_speed[i],parallax_layers[i],delta)
	player_last_position_x=player_position_x
	
func get_player_position_x()->float:
	return get_viewport().get_camera_2d().get_screen_center_position().x

func on_parallax(parallax_speed,parallax_layer,delta):
	add_position_x=parallax_speed*delta*(abs(player_position_x-player_last_position_x))*0.1
	if player_last_position_x>player_position_x:
		add_position_x=add_position_x
	elif player_last_position_x<player_position_x:
		add_position_x=-add_position_x
	else :
		add_position_x=0
	if  add_position_x!=0:
		parallax_move_data.dic_layers_move_data[parallax_layer.name]+=add_position_x
		parallax_layer.position.x+=add_position_x
		
func get_parallax_layers():
	DB.open_db()
	parallax_move_data.dic_all_layer.clear()
	for layer in get_children():
		if  layer is Node2D:
			parallax_layers.append(layer)
			parallax_move_data.dic_layers_move_data[layer.name]=0
			parallax_move_data.dic_all_layer.append(layer)
			var dic:Dictionary
			dic["room_id"]=Global.current_room
			dic["layer"]=str(layer.name)
			dic["position_x"]=0.0
			DB.insert_row(TABLE_NAME,dic)
	DB.close_db()
	
func _save_position():
	DB.open_db()
	for layer in parallax_layers:
		dic_position[layer.name]=layer.position.x
		get_condition_save(layer)
		DB.update_rows(TABLE_NAME,CONDITION_SAVE,{"position_x":layer.position.x})
	DB.close_db()
	Debug.dprint(room.name+"|视差层「保存」存档|")
	
func _load():
	DB.open_db()
	Debug.dprint(room.name+"|视差层「载入」存档|")
	for layer in parallax_layers:
		get_condition_save(layer)
		var p:float=DB.select_rows(TABLE_NAME,CONDITION_SAVE,["position_x"])[0]["position_x"]
		layer.position.x=p
		
func _delete_save():
	Debug.dprint(room.name+"|视差层删除存档|")
	
func get_condition_save(node):
	CONDITION_SAVE="room_id="+str(Global.current_room)+" and layer='"+node.name+"'"
