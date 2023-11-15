extends Node
##[必须挂载于Npcs对象根节点] Npc的状态机管理器
class_name NpcStateManager
@onready var base_state: NpcsBaseState = $base
@onready var master: Node = %Master

var npc
##npc状态历史
var npc_state_history:Array=[]
##不允许回退的状态list
var npc_unnormal_state:Array=[]
var current_state: NpcsBaseState:
	set(state):
		current_state = state
		npc.current_state = state
		if !npc_state_history.is_empty() and state==npc_state_history.back():return
		npc_state_history.push_back(state)
		if npc_state_history.size()>50:
			npc_state_history.pop_front()
var all_states: Array
var pre_start_state:NpcsBaseState
var start_state:NpcsBaseState
var start1_state:NpcsBaseState
var running_state:NpcsBaseState
var process_begin:bool=false
var attack_reset:bool=false
var current_damage:float = 0.0
var animation_speed:float = 1.0

func on_master_ready(master):
	npc = master.obj
	init(npc)

func _ready() -> void:
	EventBus.change_npc_state.connect(signal_state2state)

	
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
	npc.aniplayer.set_speed_scale(new_state.animation_speed)
	#animation_speed = new_state.animation_speed
	npc.enable_player_detection(new_state.enable_player_detection)
	npc.enable_self(new_state.enable_self)
	npc.enable_hitbox(new_state.enable_weapon)
	if new_state.player_interact_lock:
		PlayerState.add_player_lock_interact_obj(npc)
	else:
		PlayerState.remove_player_lock_interact_obj(npc)
	
func init(npc1) -> void:
	EventBus.running_obj.connect(on_running_obj)
	get_all_state(self)
	Debug.dprintinfo("[%s]NPC载入所有state." %npc.name)
	for state in all_states:
		state.npc = npc1
		state.state_manager=self
		state.aniplayer=npc.aniplayer
		init_var(state)
		state.init(all_states)
		state.init_var()
		current_state=start_state
	change_state(start1_state)

func init_var(state):
	if !state.is_normal_state:
		npc_unnormal_state.push_back(state)

#状态机启动	
func on_running_obj(name):
	if name==npc.name:
		current_state=base_state.lock_state
		npc.show()
		change_state(running_state)
		
		
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
			if npc.running_state==child.name:
				running_state=child
			if npc.starting_state==child.name:
				start_state=child
			if npc.starting1_state==child.name:
				start1_state=child
		if child:
			get_all_state(child)
			
func print_state_change(a,b):
	var format_string = "「%s」状态机切换: [%s] --> [%s]"
	var format_string1 = "[%s]->[%s]"
	var actual_string = format_string % [current_state.npc.get_name(),a, b]
	var actual_string1 = format_string1 % [a, b]
	#state_test.set_text(actual_string1)
	Debug.dprint(actual_string)
	return actual_string

##在物理方法中
func common_state():
	if !npc or npc.on_talk:return
	if npc.being_hit and ![base_state.lock_state,base_state.birth_state,base_state.death_state,base_state.behithard_state].has(current_state) and current_state.on_combat:
		state2state(base_state.behit_state)
	if npc.on_combat :
		if npc.global_position.x>npc.patrol_right.global_position.x or npc.global_position.x<npc.patrol_left.global_position.x:
			if current_state!=base_state.attack0_state:
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
func on_hurt(area:Area2D):
	if area.enable and ![base_state.dodge_state,base_state.lock_state,base_state.birth_state,base_state.death_state,base_state.behithard_state].has(current_state) and current_state.on_combat:
		current_damage = area.damage
		change_state(base_state.behit_state)
##受击事件	
func on_dodge(area:Area2D):
	var state = npc.dodge_weight_machine.process()
	if state and ![base_state.dodge_state,base_state.lock_state,base_state.birth_state,base_state.death_state,base_state.behithard_state].has(current_state) and current_state.on_combat:
		change_state(state)

##弹反受击事件	
func on_behithard(area:Area2D):
	if area.enable and ![base_state.lock_state,base_state.birth_state,base_state.death_state,base_state.behithard_state].has(current_state) and current_state.on_combat:
		current_damage = 1
		change_state(base_state.behithard_state)
		
##根据名字获取状态
func get_state_by_name(state_name):
	if !state_name:return null
	for state in all_states:
		if str(state.name).begins_with(state_name):
			return state

##获取上一个可切换状态
func get_last_normal_state():
	for i in npc_state_history.size():
		var state = npc_state_history[npc_state_history.size()-i-2]
		if !npc_unnormal_state.has(state):
			return state
			
