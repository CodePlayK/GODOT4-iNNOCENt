@icon("res://core/resource/icon/FiniteStateMachine.svg")
extends Node
##[必须挂在于Player下] 玩家状态机
class_name PlayerStateManager
@export var starting_node:Node
@export_group("Debug")
@export var changing_state:bool
@export var common_inputing:bool
@export var input2current_state:bool
@export var on_hurt2state:bool
@export var state2stating:bool
@export var listener_input:bool

@onready var player: Player = $".."
@onready var starting_state: BaseState = starting_node
@onready var test_label=%TestLabel
@onready var base_state:BaseState=$base
@onready var anime: Anime = $"../Animation/Anime"
@onready var listener: Node = $AttackListener

##重置攻击到attack0
var attack_reset:bool = true
var current_state: BaseState
var current_damage: float = 0
var all_states: Array
var barting:bool = false
var is_changing_state:bool = false
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
			if listener_input:Debug.dprintinfo("[StateManager]input进入监听,且收到true")
			return
	var common_input = input_common_state(event)
	if common_input:
		change_state(common_input)
		return
	var new_state
	if current_state:
		if input2current_state:Debug.dprintinfo("[StateManager]input进入%s" %current_state.name)
		new_state = current_state.input(event)
	if new_state:
		change_state(new_state)

func change_state(new_state: BaseState) -> void:
	if null!=current_state and null!=new_state and current_state!=new_state and new_state.pre_enter():
		print_state_change(current_state.name,new_state.name)
		if !new_state is StackingState:
			is_changing_state = true
			current_state.exit(new_state)
			current_state.common_exit()
			PlayerState.last2_state=PlayerState.last_state
			PlayerState.last_state=current_state
			current_state = new_state
			PlayerState.current_state=current_state
		new_state.load_var()
		new_state.play_animation()
		new_state.change_animation_color(new_state.change_sprite_color,new_state.pause_on_change_sprite_color)
		is_changing_state = false
		var temp_state= await new_state.enter()
		if temp_state:
			change_state(temp_state)

func physics_process(delta: float) -> void:
	var new_state = current_state.pre_physics_process(delta)
	if !new_state and !is_changing_state:
		new_state = current_state.physics_process(delta)
		var new_state2 = current_state.after_physics_process(delta)
		if new_state2 and !is_changing_state:
			change_state(new_state2)
		else:
			if new_state:
				change_state(new_state)
	else :
		change_state(new_state)

func process(delta: float) -> void:
	var new_state = current_state.process(delta)
	if new_state and !is_changing_state:
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
	if changing_state:Debug.dprintinfo(actual_string)
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
	if attack_reset and event.is_action_pressed("attack") and ![base_state.behitDamaged_state].has(current_state):
		if common_inputing:Debug.dprintwarn("[StateManager][input_common_state]切换到[attack0]")
		return base_state.attack0_state
	if event.is_action_pressed("light"):
		if common_inputing:Debug.dprintwarn("[StateManager][input_common_state]切换到[light_state]")
		return base_state.light_state
	if event.is_action_pressed("dense")&&PlayerState.denseable_flag:
		if common_inputing:Debug.dprintwarn("[StateManager][input_common_state]切换到[dense_state]")
		return base_state.dense_state
	if event.is_action_pressed("dash"):
		if common_inputing:Debug.dprintwarn("[StateManager][input_common_state]切换到[dash_state]")
		return base_state.dash_state
	return null		
	
func state2state(state,from_state):
	if state2stating:Debug.dprintinfo("[StateManager][%s]主动切换状态->[%s]" %[from_state.name,state.name])
	change_state(state)

func on_hurt(obj:HitBox):
	if !obj.enable:
		return
	PlayerState.player_be_hitting=true
	current_damage = obj.damage
	if current_state.anime_config:
		for bati in current_state.anime_config.bati_config:
			barting = bati.bating
			if barting:
				if on_hurt2state:Debug.dprintwarn("[StateManager][input_common_state]切换到[behitDamaged_state]")
				state2state(base_state.behitbati_state,current_state)
				return
	if !PlayerState.dense_flag and !PlayerState.dense_success_flag:
		if on_hurt2state:Debug.dprintwarn("[StateManager][input_common_state]切换到[behitDamaged_state]")
		change_state(base_state.behitDamaged_state)
