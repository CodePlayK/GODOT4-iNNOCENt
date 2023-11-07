##玩家状态
extends Node
var player_control_lcok:bool=false
var face_left:bool=false
var player_interact_being_locked:bool=false
var player_z_index={
	"Bedroom":0
}
var is_player_on_fighting:bool=false
var player_on_fighting:Dictionary

var player_state_history:Array=[]
var player_un_naormal_state:Array=[]
func get_last_normal_state():
	for i in player_state_history.size():
		var state = player_state_history[player_state_history.size()-i-2]
		if !player_un_naormal_state.has(state):
			return state
			
var player_lock_interact_obj:Dictionary

var player_global_position:Vector2:
	set(v2):
		player_global_position = v2
		CutsceneState.player_position = v2
var last_state:BaseState
var last2_state:BaseState
var current_state:BaseState:
	set(state):
		current_state=state
		if state==player_state_history.back():return
		player_state_history.push_back(state)
		if player_state_history.size()>20:
			player_state_history.pop_front()

var ability_lock:bool=false
var dense_flag:bool=false
var attaking:bool=false
var dense_success_flag:bool=false
var denseable_flag:bool=true
var lightable_flag:bool=true
var player_be_hitting:bool=false

func disable_player_interactive_only():
	get_tree().call_group_flags(2,"player_interactable_only","enable_all_interact",false)
	
func disable_mouse_interactable_only():
	get_tree().call_group_flags(2,"mouse_interactable_only","enable_all_interact",false)
	
func enable_player_interactive_only():
	get_tree().call_group_flags(2,"player_interactable_only","enable_all_interact",true)
	
func enable_mouse_interactable_only():
	get_tree().call_group_flags(2,"mouse_interactable_only","enable_all_interact",true)	
	
func disable_all_ineractable():
	disable_mouse_interactable_only()
	disable_player_interactive_only()
	
func enable_all_ineractable():
	enable_player_interactive_only()
	enable_mouse_interactable_only()
	
func preset_player():
	ability_lock=false
	dense_flag=false
	dense_success_flag=false
	denseable_flag=true
	lightable_flag=true
	player_be_hitting=false
	player_control_lcok=false
	
func add_player_lock_interact_obj(obj):
	if player_lock_interact_obj.keys().has(obj.name):
		return
	player_lock_interact_obj[obj.name]=obj
	
func remove_player_lock_interact_obj(obj):
	if !player_lock_interact_obj.keys().has(obj.name):
		return
	player_lock_interact_obj.erase(obj.name)
