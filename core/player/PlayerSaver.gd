extends Node
var tres_save_path
@onready var player = $".."
@onready var tl_2 = $"../TL2"

const TABLE_NAME="player"
const VERBOSITY_LEVEL: int = SQLite.QUIET  
var CONDITION_SAVE="room_id="+str(Global.current_room)
var DB:SQLite

var dic_save_data:Dictionary

func _ready():
	DB=SQLite.new()
	DB.path=Global.DB_NAME
	DB.verbosity_level = VERBOSITY_LEVEL
	_preset()
	EventBus.player_save_game.connect(_save)
	EventBus.load_game.connect(_load)
	EventBus.delete_save.connect(_delete_save)
	pass 

##初始化存档,当数据库没有记录时插入	
func _preset():
	praper_data()
	DB.open_db()
	var dic:Dictionary
	dic["room_id"]=Global.current_room
	DB.insert_row(TABLE_NAME,dic)
	DB.close_db()
	Debug.dprintinfo("Player「初始化」存档|%sa" %JSON.stringify(dic))
	_load()
	pass

func _save():
	praper_data()
	DB.open_db()
	DB.update_rows(TABLE_NAME,CONDITION_SAVE,dic_save_data)
	DB.close_db()
	Debug.dprint(player.name+"|Player「保存」存档|"+JSON.stringify(dic_save_data))
	pass
func _load():
	DB.open_db()
	var row=DB.select_rows(TABLE_NAME,CONDITION_SAVE,["*"])[0]
	DB.close_db()
	player.position=Vector2(row["position_x"],row["position_y"])
	tl_2.text=row["lb_text"]
	EventBus._player_face_left(row["face_left"]=="1")
	Debug.dprint(player.name+"|Player「载入」存档|"+JSON.stringify(row))
	pass
	
func praper_data():
	dic_save_data={
		"position_x"=player.position.x,
		"position_y"=player.position.y,
		"face_left"=PlayerState.face_left,
		"lb_text"=tl_2.text,
	}
	pass

func _on_timer_timeout():
	tl_2.text=str(int(tl_2.text)+1)
	pass 

func _delete_save():
	DirAccess.open("user://").remove(tres_save_path)
	Debug.dprint(player.name+"|Player「删除」存档|"+dic_save_data)

