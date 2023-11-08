extends Node
##[必须挂载于Npcs对象根节点] Npc的状态机管理器
class_name NpcStateManager
@onready var state_test: Label = $"../StateTest"
@onready var base_state: NpcsBaseState = $base
@onready var npc: Npcs = $".."
@onready var hitbox: Area2D = $"../Hitbox"
var current_state: NpcsBaseState:
	set(state):
		current_state = state
		npc.current_state = state
var all_states: Array
var pre_start_state:NpcsBaseState
var start_state:NpcsBaseState
var process_begin:bool=false

func _ready() -> void:
	EventBus.change_npc_state.connect(signal_state2state)
	hitbox.area_entered.connect(on_hit)

func change_state(new_state: NpcsBaseState) -> void:        
	if null!=current_state and current_state!=new_state and new_state.pre_enter():
		current_state.exit(new_state)
		process_begin = false
		print_state_change(current_state.name,new_state.name)
		current_state = new_state
		load_var(new_state)
		var temp_state=await new_state.enter()
		process_begin = true
		if temp_state:
			change_state(temp_state)

##载入每个状态的变量
func load_var(new_state:NpcsBaseState):
	npc.on_combat = new_state.on_combat
	npc.on_fighting = new_state.on_fighting
	npc.enable_player_detection(new_state.enable_player_detection)
	npc.enable_self(new_state.enable_self)
	npc.enable_weapon (new_state.enable_weapon)
	npc.enable_weapon (new_state.enable_weapon)
	if new_state.player_interact_lock:
		PlayerState.add_player_lock_interact_obj(npc)
	else:
		PlayerState.remove_player_lock_interact_obj(npc)

func init(npc1) -> void:
	EventBus.running_obj.connect(on_running_obj)
	get_all_state(self)
	#Debug.dprintinfo("[%s]NPC载入所有state." %npc.name)
	for state in all_states:
		state.npc = npc1
		state.state_manager=self
		state.init(all_states)
		current_state=pre_start_state
	change_state(start_state)

#状态机启动	
func on_running_obj(name):
	if name==npc.name:
		current_state=base_state.lock_state
		change_state(base_state.birth_state)
		
func physics_process(delta: float) -> void:
	if null ==current_state or !process_begin :return
	var temp_state=common_state()
	if temp_state!=null:
		change_state(temp_state)
		return
	var new_state = current_state.pre_physics_process(delta)
	if !new_state:
		new_state =await current_state.physics_process(delta)
		var new_state2 = current_state.after_physics_process(delta)
		if new_state2:
			change_state(new_state2)
		else:
			if new_state:
				change_state(new_state)
	else :
		change_state(new_state)
		
func input(event: InputEvent) -> void:
	if null ==current_state:return
	var new_state
	if current_state:
		new_state = current_state.input(event)
	if new_state:
		change_state(new_state)

func process(delta: float) -> void:
	if null ==current_state or !process_begin :return
	var new_state = current_state.process(delta)
	if new_state:
		change_state(new_state)
		
##遍历子节点并获取所有状态
func get_all_state(node:Node):
	for child in node.get_children():
		if child is NpcsBaseState:
			all_states.append(child)
			if npc.starting_state==child.name:
				pre_start_state=child
			elif npc.starting_state1==child.name:
				start_state=child
		if child:
			get_all_state(child)
			
func print_state_change(a,b):
	var format_string = "「%s」状态机切换: [%s] --> [%s]"
	var format_string1 = "[%s]->[%s]"
	var actual_string = format_string % [current_state.npc.get_name(),a, b]
	var actual_string1 = format_string1 % [a, b]
	state_test.set_text(actual_string1)
	#Debug.dprint(actual_string)
	return actual_string

##在物理方法中
func common_state():
	if !npc or npc.on_talk:return
	if npc.on_combat :
		if npc.global_position.x>npc.patrol_right.global_position.x or npc.global_position.x<npc.patrol_left.global_position.x:
			if current_state!=base_state.attack_state:
				state2state(base_state.patrol_state)
	return null		

##状态间主动切换
func state2state(state):
	#Debug.dprint("[%s][%s]主动切换状态->[%s]" %[npc.name,current_state.name,state.name])
	change_state(state)

##信号通知主动改变状态
func signal_state2state(npc_name,state_name):
	if !npc_name == npc.obj_name:return
	state2state(get_state_by_name(state_name))

##受击事件	
func on_hit(area:Area2D):
	if ![base_state.lock_state,base_state.birth_state,base_state.death_state,base_state.behithard_state].has(current_state) and current_state.on_combat:
		change_state(base_state.behit_state)
		
##根据名字获取状态
func get_state_by_name(state_name):
	for state in all_states:
		if str(state.name).begins_with(state_name):
			return state
	
