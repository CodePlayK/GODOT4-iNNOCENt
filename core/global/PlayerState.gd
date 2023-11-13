##玩家状态
extends Node
var player:Player
##玩家操控锁
var player_control_lcok:bool=false
##面朝左
var face_left:bool=false:
	set(f):
		face_left = f
		if f:
			face_left_normalize = -1
		else :
			face_left_normalize = 1
var face_left_normalize:int=1
##玩家是否可以进行交互
var player_interact_being_locked:bool=false
##玩家交互锁对象{对象名,对象}
var player_lock_interact_obj:Dictionary
##玩家在不同房间的zindex
var player_z_index={
	"Bedroom":0
}
##玩家正处于在战斗中[chase,attack]
var is_player_on_fighting:bool=false:
	set(f):
		is_player_on_fighting = f
		if player:
			player.ui.player_on_fighting_changed(f)

##正在与玩家战斗的对象{对象名,对象}
var player_on_fighting:Dictionary
var max_health:int = 10
var last_health:int = 10
var health:int = 10:
	set(h):
		last_health = health
		if h <= 0:h = max_health
		health = h
		if player:
			player.ui.on_health_changed()

##玩家状态历史
var player_state_history:Array=[]
##不允许回退的状态list
var player_unnormal_state:Array=[]
##玩家全局坐标
var player_global_position:Vector2:
	set(v2):
		player_global_position = v2
		CutsceneState.player_position = v2
var player_screen_position:Vector2
var max_height:float
var current_height:float:
	set(f):
		current_height = f
		if light_flag:
			max_height = max(max_height,f)
var start_jump_height:float
##上一个状态
var last_state:BaseState
##前二个状态
var last2_state:BaseState
##当前状态
var current_state:BaseState:
	set(state):
		current_state=state
		if state==player_state_history.back():return
		player_state_history.push_back(state)
		if player_state_history.size()>50:
			player_state_history.pop_front()
##技能锁定
var ability_lock:bool=false
##正在弹反的标记
var dense_flag:bool=false
##能够弹反的标记
var denseable_flag:bool=true
##弹反结果的标记
var dense_success_flag:bool=false
##是否正在攻击
var attacking:bool=false
##能够轻化
var lightable_flag:bool=true
var light_flag:bool=false
##正在受击
var player_be_hitting:bool=false
var double_jump_able:bool=false

##获取上一个可切换状态
func get_last_normal_state():
	for i in player_state_history.size():
		var state = player_state_history[player_state_history.size()-i-2]
		if !player_unnormal_state.has(state):
			return state
##只禁用玩家接触交互obj			
func disable_player_interactive_only():
	get_tree().call_group_flags(2,"player_interactable_only","enable_all_interact",false)
##只禁用鼠标交互obj		
func disable_mouse_interactable_only():
	get_tree().call_group_flags(2,"mouse_interactable_only","enable_all_interact",false)
##只启用玩家接触交互obj			
func enable_player_interactive_only():
	get_tree().call_group_flags(2,"player_interactable_only","enable_all_interact",true)
##只启用鼠标交互obj		
func enable_mouse_interactable_only():
	get_tree().call_group_flags(2,"mouse_interactable_only","enable_all_interact",true)	
##禁用所有交互物	
func disable_all_ineractable():
	disable_mouse_interactable_only()
	disable_player_interactive_only()
##启用所有交互物
func enable_all_ineractable():
	enable_player_interactive_only()
	enable_mouse_interactable_only()
##重置player	
func preset_player():
	ability_lock=false
	dense_flag=false
	dense_success_flag=false
	denseable_flag=true
	lightable_flag=true
	player_be_hitting=false
	player_control_lcok=false
##添加到玩家交互锁中	
func add_player_lock_interact_obj(obj):
	if player_lock_interact_obj.keys().has(obj.name):
		return
	player_lock_interact_obj[obj.name]=obj
##移除玩家交互锁	
func remove_player_lock_interact_obj(obj):
	if !player_lock_interact_obj.keys().has(obj.name):
		return
	player_lock_interact_obj.erase(obj.name)

func on_player_ready(player1:Player):
	player = player1
	player.ui.health_bar.max_value = max_health
	player.ui.health_bar_back.max_value = max_health
