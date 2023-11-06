@tool
extends Node
var title_able:bool=true
var cutscene_playing:bool=false:
	set(f):
		if f:
			if !cutscene_playing:
				EventBus._cutscene_is_playing()
				cutscene_playing=f
		else:
			if cutscene_playing:
				EventBus._cutscene_finished()
				cutscene_playing=f
var dic_cutscenes:Dictionary={
	"0_0_0":"wake_ifrit_up",
	"0_1_0":"ready_to_leave_bedroom",
	"0_2_1":"first_training",
}
var cutscener_playing:bool
var current_cutscene:String="0_0_0"
var test_var_String:String
var test_var_Vector2:Vector2
var test_var_int:int
var test_var_float:float
var test_var_Array:Array
var test_var_Dictionary:Dictionary
var test_var_Resource:Resource

var player_position:Vector2
