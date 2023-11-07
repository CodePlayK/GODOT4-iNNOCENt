extends Node
##[必须挂载于NpcStateManager根节点] npc的基础状态
class_name NpcsBaseState
@onready var idle_state: NpcsBaseState
@onready var ground_state: NpcsBaseState
@onready var patrol_state: NpcsBaseState
@onready var combat_state: NpcsBaseState
@onready var chase_state: NpcsBaseState
@onready var attack_state: NpcsBaseState
@onready var behit_state: NpcsBaseState
@onready var death_state: NpcsBaseState
@onready var birth_state: NpcsBaseState
@onready var lock_state: NpcsBaseState
@onready var talk_state: NpcsBaseState
@export_category("当前状态配置")
##当前state是否属于战斗状态(玩家不可与me交互)
@export var on_combat:bool = false
var on_combat_real:bool = false:
	set(f):
		on_combat_real = f
@export var on_fighting:bool = false
var on_fighting_real:bool = false:
	set(f):
		on_fighting_real = f
##当前state启用npc的对player检测,比如寻敌
@export var enable_player_detection:bool
var enable_player_detection_real:bool:
	set(flag):
		enable_player_detection_real=flag
		npc.enable_player_detection(flag)
##当前state启用npc自身的检测
@export var enable_self:bool
var enable_self_real:bool:
	set(flag):
		enable_self_real=flag
		npc.enable_self(flag)
##当前state启用npc的武器的碰撞检测		
@export var enable_weapon:bool
var enable_weapon_real:bool:
	set(flag):
		enable_weapon_real=flag
		npc.enable_weapon(flag)
##当前state是否锁定player与可交互obj的交互		
@export var player_interact_lock:bool
var player_interact_lock_real:bool:
	set(flag):
		player_interact_lock_real=flag
		if flag:
			PlayerState.add_player_lock_interact_obj(npc)
		else:
			PlayerState.remove_player_lock_interact_obj(npc)
##当前状态是否要转换sprite
@export var change_sprite:bool=true
##当前状态是否要颜色覆盖sprite
@export var change_sprite_color:bool=false
##要覆盖sprite的颜色
@export var sprite_color:Color
var npc:Npcs
var state_manager:NpcStateManager
##初始化事件
func init(all_states) -> void:
	for state in all_states:
		var state_name =state.get_name()
		if "idle"==state_name:idle_state=state
		if "ground"==state_name:ground_state=state
		if "patrol"==state_name:patrol_state=state
		if "combat"==state_name:combat_state=state
		if "chase"==state_name:chase_state=state
		if "attack"==state_name:attack_state=state
		if "behit"==state_name:behit_state=state
		if "death"==state_name:death_state=state
		if "birth"==state_name:birth_state=state
		if "lock"==state_name:lock_state=state
		if "talk"==state_name:talk_state=state
	connect_signal()
	
	
##进入该状态的方法，每次进入都会执行，在pre_physics_process之前进行
func pre_enter() -> bool:
	return true
	
func load_var() -> bool:
	on_combat_real=on_combat
	on_fighting_real=on_fighting
	enable_player_detection_real=enable_player_detection
	enable_self_real=enable_self
	enable_weapon_real=enable_weapon
	player_interact_lock_real=player_interact_lock
	return true

##进入该状态的方法，每次进入都会执行，在pre_physics_process之前进行
func enter() -> NpcsBaseState:
	if change_sprite:play_animation()
	change_animation_color(change_sprite_color)
	return null
	
##退出该状态的方法，每次进入都会执行，在physics_process之后进行
func exit(state:NpcsBaseState):
	pass
	
##有输入事件的方法,不确定与物理帧方法的顺序。慎用
func input(event: InputEvent) -> NpcsBaseState:
	return null

##游戏实际帧数的处理方法，godot默认物理帧FPS为60
#当游戏运行帧数大于物理帧FPS时：可通过传递delta获得与物理帧数同样效果
#而运行帧数小于物理帧数时，即使传递delta也可能导致问题
#运行顺序不确定
func process(delta: float) -> NpcsBaseState:
	return null
	
##物理帧方法，当变量涉及+=或者-+等随时间累计情况时，需要*delta
func physics_process(delta: float) -> NpcsBaseState:
	return 
	
##物理帧中先执行的方法
func pre_physics_process(delta: float)->NpcsBaseState:
	return null
	
##物理帧中后执行的方法	
func after_physics_process(delta: float)->NpcsBaseState:
	return null
	
##连接信号方法		
func connect_signal():
	return
		
##获取npc当前面朝方向
func get_npc_faced_direction():
	if npc.base.scale.x <0:
		return -1
	else:
		return 1
		
func play_animation():
	npc.base.play(self.get_name())

func change_animation_color(flag:bool=false):
	npc.base.material.set_shader_parameter("color",sprite_color)
	npc.base.material.set_shader_parameter("enable",flag)
	if flag:
		npc.base.pause()
	else:
		npc.base.play()
		

##判断玩家与当前npc的相对左右位置,右=1,左=-1	
func get_relative_position_x_2_player()->int:
	if PlayerState.player_global_position.x>=npc.global_position.x:
		return 1
	else:
		return -1
