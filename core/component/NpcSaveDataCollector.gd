extends Node
##[必须挂载于目标储存对象根节点,必须有单一saver子节点] 配置单一对象存档数据的父类，只负责数据组装与属性赋值
class_name SaveDataCollector
@onready var npc = $".."
var saver
signal save
signal preset
var dic_save_data:Dictionary

func _ready() -> void:
	npc.ready.connect(on_obj_ready)

func on_obj_ready():
	saver=get_children()[0]
	saver.load_save.connect(_load_save)
	EventBus.save_game.connect(_pre_save_game)
	_preset()
	
##初始化数据	
func _preset():
	custom_data()
	dic_save_data["position_x"]=npc.position.x
	dic_save_data["position_y"]=npc.position.y
	dic_save_data["npc_face_left"]=npc.animation.scale.x
	preset.emit()
	pass
	
##前置保存游戏	
func _pre_save_game():
	custom_data()
	dic_save_data["position_x"]=npc.position.x
	dic_save_data["position_y"]=npc.position.y
	dic_save_data["npc_face_left"]=npc.animation.scale.x
	save.emit()
	pass
	
##载入存档
func _load_save():
	npc.position.x=dic_save_data["position_x"]
	npc.position.y=dic_save_data["position_y"]
	EventBus._obj_set_face_left(npc.name,dic_save_data["npc_face_left"])
	load_custom_data()
	
##子类重写，用于配置要存档的数据
func custom_data():
	pass
	
##子类重写，用于载入存档的数据
func load_custom_data():
	pass
