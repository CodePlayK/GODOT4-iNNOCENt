extends Node
##[必须为SaveDataCollector节点的唯一子节点] 用于player对象的存档与读档案，不负责数据组装与赋值，只负责IO交互
class_name PlayerSaver
@onready var player = $"../.."
@onready var save_data_collector = $".."
signal load_save
const TABLE_NAME="player"
const VERBOSITY_LEVEL: int = SQLite.QUIET  
var CONDITION_SAVE
var DB:SQLite

func _ready():
	DB=SQLite.new()
	DB.path=Global.DB_NAME
	DB.verbosity_level = VERBOSITY_LEVEL
	EventBus.load_game.connect(_load_game)
	EventBus.delete_save.connect(_delete_save)
	save_data_collector.save.connect(_save)
	save_data_collector.preset.connect(_preset)
	await save_data_collector.ready
	pass 
##初始化存档,当数据库没有记录时插入	
func _preset():
	DB.open_db()
	var dic:Dictionary
	dic["room_id"]=Global.current_room
	dic["data"]=JSON.stringify(save_data_collector.dic_save_data)
	DB.insert_row(TABLE_NAME,dic)
	DB.close_db()
	#Debug.dprintinfo("%s|player「初始化」存档|%sa" %[player.name,JSON.stringify(dic)])
	_load()
	pass
##保存数据到数据库
func _save():
	DB.open_db()
	var dic:Dictionary
	dic["room_id"]=Global.current_room
	dic["data"]=JSON.stringify(save_data_collector.dic_save_data)
	get_condition_save(player)
	DB.update_rows(TABLE_NAME,CONDITION_SAVE,dic)
	DB.close_db()
	#Debug.dprint("%s|player「保存」存档|%s" %[player.name,JSON.stringify(dic)])
	pass
##载入数据	
func _load():
	DB.open_db()
	get_condition_save(player)
	var data=JSON.parse_string(DB.select_rows(TABLE_NAME,CONDITION_SAVE,["data"])[0]["data"])
	save_data_collector.dic_save_data=data
	#Debug.dprint("%s|player「载入」存档|%s" %[player.name,JSON.stringify(data)])
	load_save.emit()
	pass	
	
func _load_game():
	_load()
	pass

func _delete_save():
	Debug.dprint("%s|player「删除」存档|" %player.name)
	
func get_condition_save(node):
	CONDITION_SAVE="room_id="+str(Global.current_room)
