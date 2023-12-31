##全局单例
extends Node
var palyerDead=false
var playerDeadTimes=0
var state_ui_text:String = ""
const parallax_move_data_source_path="res://core/room/common/parallax/parallax_move_data.tres"
const parallax_save_data_source_path="res://core/room/common/parallax/parallax_save_data.tres"

var current_room:int=Global.rooms.ROOM_1
var last_room:int=Global.rooms.ROOM_1

var playing_transition:bool=false
var door_locked:bool=false
var current_main_layer:Node2D
var room_transition:Dictionary={}
var ground_lines:Array
enum ScreenShakeType {
	NOISE,
	SWAY
}
enum transition_type {
	RIGHT_ENTER,
	RIGHT_LEFT,
	LEFT_ENTER,
	LEFT_LEFT,
	MID_ENTER,
	MID_LEFT,
	FADE_OUT,
	FADE_IN
}
enum rooms
{	
	NA=0,
	ROOM_1=1,
	ROOM_2=2,
	ROOM_CUT=3
}

var DB_NAME="user://data/TEST_1"

func lock_room_doors():
	door_locked=true
	EventBus._lock_doors()
func unlock_room_doors():
	door_locked=false
	EventBus._unlock_doors()
