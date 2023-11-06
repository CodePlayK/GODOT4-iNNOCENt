extends Node
##[必须挂在于Player下] 玩家状态机
class_name PlayerStateManager
@export var starting_node:Node
@onready var player: Player = $".."
@onready var starting_state: BaseState = starting_node
@onready var test_label=%TestLabel
@onready var base_state:BaseState=%base
@onready var aniplayer: AnimationPlayer = $Aniplayer

var current_state: BaseState
var all_states: Array

func change_state(new_state: BaseState) -> void:        
	if null!=current_state and current_state!=new_state and new_state.pre_enter():
		current_state.exit(new_state)
		PlayerState.last2_state=PlayerState.last_state
		PlayerState.last_state=current_state
		print_a_to_b(current_state.name,new_state.name)
		current_state = new_state
		PlayerState.current_state=current_state
		var temp_state= await current_state.enter()
		if temp_state:
			change_state(temp_state)

func init(player: Player) -> void:
	EventBus.player_control_lock.connect(_on_player_control_lock)
	Debug.dprintinfo("Player载入所有state")
	get_childen_node(self)
	for state:BaseState in all_states:
		state.player = player
		state.state_manager=self
		state.aniplayer = aniplayer
		state.init(all_states)
		state.init_var()
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
			
func print_a_to_b(a,b):
	var format_string = "「Player」状态机切换: [%s] --> [%s]"
	var format_string1 = "[%s]->[%s]"
	var actual_string = format_string % [a, b]
	var actual_string1 = format_string1 % [a, b]
	#Debug.dprintinfo(actual_string)
	test_label.text=actual_string1
	return actual_string

func _on_player_tree_exiting():
	change_state(base_state.idle_state)
	pass 

func _on_player_control_lock(state):
	if state:
		change_state(base_state.talk_state)
	else :
		change_state(base_state.idle_state)
		
func common_state():
	if PlayerState.player_control_lcok:return null
	if Input.is_action_just_pressed("attack"):
		#Debug.dprinterr("[Player][common_state]切换到[light_state]")
		return base_state.attack0_state
	if Input.is_action_just_pressed("light"):
		#Debug.dprinterr("[Player][common_state]切换到[light_state]")
		return base_state.light_state
	if Input.is_action_just_pressed("dense")&&PlayerState.denseable_flag:
		#Debug.dprinterr("[Player][common_state]切换到[dense_state]")
		return base_state.dense_state
	if PlayerState.player_be_hitting and !PlayerState.dense_flag and !PlayerState.dense_success_flag:
		#Debug.dprinterr("[Player][common_state]切换到[behitDamaged_state]")
		return base_state.behitDamaged_state
	return null		

func state2state(state,from_state):
	#Debug.dprintinfo("[Player][%s]主动切换状态->[%s]" %[from_state.name,state.name])
	change_state(state)
