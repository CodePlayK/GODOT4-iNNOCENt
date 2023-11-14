extends Node
##[必须挂在于Player下] 玩家状态机
class_name PlayerStateManager
@export var starting_node:Node
@onready var player: Player = $".."
@onready var starting_state: BaseState = starting_node
@onready var test_label=%TestLabel
@onready var base_state:BaseState=%base
@onready var listener: Node = $listener
@onready var aniplayer: AnimationPlayer = $Aniplayer

##重置攻击到attack0
var attack_reset:bool = true
var current_state: BaseState
var all_states: Array

func change_state(new_state: BaseState) -> void:
	if new_state == base_state.behit_state:
		pass
	if null!=current_state and null!=new_state and current_state!=new_state and new_state.pre_enter():
		current_state.exit(new_state)
		PlayerState.last2_state=PlayerState.last_state
		PlayerState.last_state=current_state
		print_state_change(current_state.name,new_state.name)
		current_state = new_state
		PlayerState.current_state=current_state
		new_state.load_var()
		if new_state.is_animation_play():
			new_state.play_animation()
		new_state.change_animation_color(new_state.change_sprite_color)
		var temp_state= await current_state.enter()
		if temp_state:
			change_state(temp_state)
			
func load_var(new_state):
	pass
			
func init_var(state):
	if !state.is_normal_state:
		PlayerState.player_unnormal_state.push_back(state)

func init(player: Player) -> void:
	EventBus.player_control_lock.connect(_on_player_control_lock)
	Debug.dprintinfo("Player载入所有state")
	get_childen_node(self)
	for state:BaseState in all_states:
		state.player = player
		state.state_manager=self
		state.aniplayer=aniplayer
		state.init(all_states)
		state.init_var()
		init_var(state)
	current_state=starting_state
	PlayerState.player_state_history.push_back(base_state.idle_state)
	change_state(starting_state)

func physics_process(delta: float) -> void:
	var temp_state=common_state()
	if temp_state!=null:
		change_state(temp_state)
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
		
func input(event: InputEvent) -> void:
	if listener.enable:
		if listener.input(event):return
	var new_state
	if current_state:
		new_state = current_state.input(event)
	if new_state:
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
	Debug.dprintinfo(actual_string)
	test_label.text=actual_string1
	return actual_string

func _on_player_tree_exiting():
	change_state(base_state.idle_state)

func _on_player_control_lock(state):
	if state:
		change_state(base_state.talk_state)
	else :
		change_state(base_state.idle_state)
		
func common_state():
	if PlayerState.player_control_lcok:return null
	if attack_reset and Input.is_action_just_pressed("attack"):
		#Debug.dprinterr("[Player][common_state]切换到[light_state]")
		return base_state.attack0_state
	if Input.is_action_just_pressed("light"):
		#Debug.dprinterr("[Player][common_state]切换到[light_state]")
		return base_state.light_state
	if Input.is_action_just_pressed("dense")&&PlayerState.denseable_flag:
		#Debug.dprinterr("[Player][common_state]切换到[dense_state]")
		return base_state.dense_state
	if Input.is_action_just_pressed("dash"):
		return base_state.dash_state
	return null		

func state2state(state,from_state):
	#Debug.dprintinfo("[Player][%s]主动切换状态->[%s]" %[from_state.name,state.name])
	change_state(state)

func on_hurt(obj:Area2D):
	if !obj.enable:
		return
	PlayerState.player_be_hitting=true
	if !PlayerState.dense_flag and !PlayerState.dense_success_flag:
		#Debug.dprinterr("[Player][common_state]切换到[behitDamaged_state]")
		change_state(base_state.behitDamaged_state)
