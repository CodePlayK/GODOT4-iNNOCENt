extends Node
var tres_save_path
@onready var player = $".."
@onready var tl_2 = $"../TL2"
@export var player_save_data:PlayerSaveData

var dic_save_data:Dictionary

func _ready():
	EventBus.save_game_player.connect(_save)
	EventBus.load_game.connect(_load)
	EventBus.delete_save.connect(_delete_save)
	get_save_path()
	pass 

func _save():
	praper_data()
	get_save_path()
	ResourceSaver.save(player_save_data,tres_save_path)
	Debug.dprint(player.name+"|Player「保存」存档|"+tres_save_path)
	pass
func _load():
	get_save_path()
	if !FileAccess.file_exists(tres_save_path):
		push_error(player.name+"|未找到Player存档|"+tres_save_path)
		return
	player_save_data=ResourceLoader.load(tres_save_path)
	Debug.dprint(player.name+"|Player「载入」存档|"+tres_save_path)
	player.position=player_save_data.player_position
	tl_2.text=player_save_data.test_txt
	pass
	
func praper_data():
	player_save_data.player_position=player.position
	player_save_data.test_txt=tl_2.text
	dic_save_data={
		"player_position.x"=player.position.x,
		"player_position.y"=player.position.y,
		"tl_2"=tl_2.text
	}
	#var file=FileAccess.open(save_path,FileAccess.WRITE)
	pass

func _on_timer_timeout():
	tl_2.text=str(int(tl_2.text)+1)
	pass 

func _delete_save():
	DirAccess.open("user://").remove(tres_save_path)
	Debug.dprint(player.name+"|Player「删除」存档|"+tres_save_path)

func get_save_path():
	tres_save_path="user://save_player_data_"+str(Global.current_room)+".tres"
