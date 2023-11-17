extends Node
##[必须挂在于Player下] 玩家状态机
class_name PlayerStateManager
@export var starting_node:Node
@export_group("Debug")
@export var debug_change_state:bool
@export var debug_common_input:bool
@export var debug_common_state:bool
@export var debug_state2state:bool
@export var debug_listener_input:bool

@onready var player: Player = $".."
@onready var starting_state: BaseState = starting_node
@onready var test_label=%TestLabel
@onready var base_state:BaseState=%base
@onready var anime: Anime = $"../Animation/Anime"
@onready var stacking: Node = $Stacking
@onready var listener: Node = $AttackListener

##重置攻击到attack0
var attack_reset:bool = true
var current_state: BaseState
var all_states: Array
var barting:bool = false
	
func init(player: Player) -> void:
	anime.animes.clear()
	EventBus.player_control_lock.connect(_on_player_control_lock)
	Debug.dprintinfo("Player载入所有state")
	get_childen_node(self)
	for state:BaseState in all_states:
		state.player = player
		state.state_manager=self
		state.anime=anime#将anime注入每一个状态
		state.init(all_states)#通知状态init
		state.init_var()
		init_var(state)
	current_state=starting_state
	PlayerState.player_state_history.push_back(base_state.idle_state)
	anime.import()##通知anime开始init
	change_state(starting_state)

func init_var(state):
	if !state.is_normal_state:#将所有非正常状态缓存
		PlayerState.player_unnormal_state.push_back(state)
	anime.animes.append(state.get_anime_config())##将每个状态的anime配置注入到Anime中
		
func input(event: InputEvent) -> void:
	if listener.enable:
		if listener.input(event):
			if debug_listener_input:Debug.dprintinfo("[状态机input进入监听,且收到true")
			return
	var new_state
	var common_input = input_common_state(event)
	if common_input:
		change_state(common_input)
		return
	if current_state:
		new_state = current_state.input(event)
	if new_state:
		change_state(new_state)

func change_state(new_state: BaseState) -> void:
	if null!=current_state and null!=new_state and current_state!=new_state and new_state.pre_enter():
		if !new_state.is_stacking_state:
			current_state.exit(new_state)
			current_state.common_exit()
			PlayerState.last2_state=PlayerState.last_state
			PlayerState.last_state=current_state
			print_state_change(current_state.name,new_state.name)
			current_state = new_state
			PlayerState.current_state=current_state
		new_state.load_var()
		new_state.play_animation()
		new_state.change_animation_color(new_state.change_sprite_color)
		var temp_state= await current_state.enter()
		if temp_state:
			change_state(temp_state)

func physics_process(delta: float) -> void:
	var new_state = current_state.pre_physics_process(delta)
	if !new_state:
		new_state = current_state.physics_process(delta)
		var new_state2 = current_state.after_physics_process(delta)
		if new_state2:
			change_state(new_state2)
		else:
			if new_state:
				change_state(new_state)
	else :
		change_state(new_state)

func process(delta: float) -> void:
	var new_state = current_state.process(delta)
	if new_state:
		change_state(new_state)

func get_childen_node(node:Node):
	for child in node.get_children():
		if child is BaseState:
			all_states.append(child)
		if child:
			get_childen_node(child)
			
func print_state_change(a,b):
	var format_string = "「Player」状态机切换: [%s] --> [%s]"
	var format_string1 = "[%s]->[%s]"
	var actual_string = format_string % [a, b]
	var actual_string1 = format_string1 % [a, b]
	test_label.text=actual_string1
	if debug_change_state:Debug.dprintinfo(actual_string)
	return actual_string

func _on_player_tree_exiting():
	change_state(base_state.idle_state)

func _on_player_control_lock(state):
	if state:
		change_state(base_state.talk_state)
	else :
		change_state(base_state.idle_state)
		
func input_common_state(event:InputEvent):
	if PlayerState.player_control_lcok:return null
	if attack_reset and event.is_action_pressed("attack"):
		if debug_common_input:Debug.dprinterr("[Player][input_common_state]切换到[light_state]")
		return base_state.attack0_state
	if event.is_action_pressed("light"):
		if debug_common_input:Debug.dprinterr("[Player][input_common_state]切换到[light_state]")
		return base_state.light_state
	if event.is_action_pressed("dense")&&PlayerState.denseable_flag:
		if debug_common_input:Debug.dprinterr("[Player][input_common_state]切换到[dense_state]")
		return base_state.dense_state
	if event.is_action_pressed("dash"):
		if debug_common_input:Debug.dprinterr("[Player][input_common_state]切换到[dash_state]")
		return base_state.dash_state
	return null		
	
func state2state(state,from_state):
	if debug_state2state:Debug.dprintinfo("[Player][%s]主动切换状态->[%s]" %[from_state.name,state.name])
	change_state(state)

func on_hurt(obj:HitBox):
	if !obj.enable:
		return
	PlayerState.player_be_hitting=true
	#if current_state.anime_config:
		#for bati in current_state.anime_config.bati_config:
			#barting = bati.bating
			#if barting:
				#Debug.dprintinfo("baitizhong")
				#stacking.on_bating(obj,current_state.anime_config.bati_config)
				#break
	if !PlayerState.dense_flag and !PlayerState.dense_success_flag:
		if debug_common_state:Debug.dprinterr("[Player][input_common_state]切换到[behitDamaged_state]")
		change_state(base_state.behitDamaged_state)
