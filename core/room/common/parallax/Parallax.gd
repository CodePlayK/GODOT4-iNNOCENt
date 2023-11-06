extends Node
#此节点下的第一代子节点会作为视差层
@onready var room = $".."

@export var rsource:Node
@export var parallax_layer_speed_0:=7
@export var parallax_layer_speed_1:=17
@export var parallax_layer_speed_2:=17
@export var parallax_layer_speed_2_5:=17
@export var parallax_layer_speed_3:=17
@export var parallax_layer_speed_4:=17
@export var parallax_layer_speed_5:=17
@export var parallax_layer_speed_6:=17
@export var parallax_layer_speed_7:=17


var save_path :String
var parallax_layers:Array=[]
var parallax_layers_speed:Array[int]=[]

var player_last_position_x:float=0.0
var player_position_x:float=0
var add_position_x=0
var dic_position:Dictionary={}
@onready var parallax_start=%ParallaxStart
@export_file var parallax_save_data
@export_file var parallax_move_data

func _ready() -> void:
	parallax_move_data=preload(Global.parallax_move_data_source_path)
	parallax_save_data=preload(Global.parallax_save_data_source_path)
	EventBus.player_save_game.connect(_save_position)
	EventBus.load_game.connect(_load)
	EventBus.delete_save.connect(_delete_save)
	parallax_save_data=parallax_save_data.duplicate()
	save_path ="user://save_"+room.name+"_parallax_position.tres"
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



func _physics_process(delta: float) -> void:
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
	for layer in get_children():
		if  layer is Node2D:
			parallax_layers.append(layer)
			parallax_move_data.dic_layers_move_data[layer.name]=0
			parallax_move_data.dic_all_layer.append(layer)
func _save_position():
	for layer in parallax_layers:
		dic_position[layer.name]=layer.position.x
	parallax_save_data.dic_position=dic_position
	ResourceSaver.save(parallax_save_data,save_path)
	Debug.dprint(room.name+"|视差层「保存」存档|"+save_path)
	
func _load():
	if	!FileAccess.file_exists(save_path):
		push_warning(room.name+"|未找到视差层存档|"+save_path)
		return
	parallax_save_data=ResourceLoader.load(save_path)
	Debug.dprint(room.name+"|视差层「载入」存档|"+save_path)
	for layer in parallax_layers:
		layer.position.x=float(parallax_save_data.dic_position[layer.name])
	pass
func _delete_save():
	DirAccess.open("user://").remove(save_path)
	Debug.dprint(room.name+"|视差层删除存档|"+save_path)
