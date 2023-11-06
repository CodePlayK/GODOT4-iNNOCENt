extends Node2D
const ROOM_1_PATH="res://core/room/room_1/room_1.tscn"
const ROOM_2_PATH="res://core/room/room_2/room_2.tscn"
const CUTSCENER_PATH="res://addons/Cutscener/main/main.tscn"
var dic_room_path:Dictionary
const src_path = "res://test/data/TEST_1.tres"
const des_path = "user://data/TEST_1.db"
const save_path = "user://data"
func _ready():
	resfile_2_userfile(src_path,des_path)
	dic_room_path[Global.rooms.ROOM_1]=ROOM_1_PATH
	dic_room_path[Global.rooms.ROOM_2]=ROOM_2_PATH
	dic_room_path[Global.rooms.ROOM_CUT]=CUTSCENER_PATH
	EventBus.change_rooms.connect(_change_rooms)
	var config = load_json(CutscenerGlobal.CONFIG_DATA_FILE_PATH)
	if config["run_type"] == 0:
		_change_rooms(Global.rooms.ROOM_1)
	#_change_rooms(Global.rooms.ROOM_1)
	
func load_room(room_path:String):
	var room = load(room_path).instantiate()
	get_tree().root.add_child(room)
	get_tree().current_scene=room
	
func _change_rooms(room_id):
	if dic_room_path.has(room_id):
		Global.last_room=Global.current_room
		get_tree().current_scene.queue_free()
		await get_tree().current_scene.tree_exited
		Global.current_room=room_id
		Debug.dprintinfo("房间切换:["+str(Global.last_room)+"]-->["+str(Global.current_room)+"]")
		load_room(dic_room_path[room_id])
		PlayerState.preset_player()

		
func resfile_2_userfile(src_path,des_path):
	DirAccess.make_dir_absolute(save_path)
	var src_file = FileAccess.open(src_path,FileAccess.READ)
	if !src_file:
		Debug.dprinterr("源文件打开失败！ ["+src_path+"]")
		return
	if src_file.file_exists(des_path):
		Debug.dprintinfo("目标文件已存在！["+des_path+"]")
		return	
	var des_file = FileAccess.open(des_path,FileAccess.WRITE)
	var size = src_file.get_length()
	var buffer=src_file.get_buffer(size)
	des_file.store_buffer(buffer)
	Debug.dprintinfo("存档数据不存在，新建数据库在User目录下！["+des_path+"]")
	src_file.close()
	des_file.close()
	
func load_json(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	if OK!=error:
		Debug.dprinterr("执行器载入json数据失败![%s]" %error)
	var data_received = json.data as Dictionary
	return data_received
