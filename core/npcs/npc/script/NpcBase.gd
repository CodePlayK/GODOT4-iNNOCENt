extends Node
##[必须挂载于NpcStateManager根节点] npc的基础状态
class_name NpcsBaseState
@onready var idle_state: NpcsBaseState
@onready var ground_state: NpcsBaseState
@onready var patrol_state: NpcsBaseState
@onready var combat_state: NpcsBaseState
@onready var chase_state: NpcsBaseState
@onready var attack0_state: NpcsBaseState
@onready var attack1_state: NpcsBaseState
@onready var attack2_state: NpcsBaseState
@onready var attack3_state: NpcsBaseState
@onready var behit_state: NpcsBaseState
@onready var behithard_state: NpcsBaseState
@onready var death_state: NpcsBaseState
@onready var birth_state: NpcsBaseState
@onready var lock_state: NpcsBaseState
@onready var talk_state: NpcsBaseState
@onready var dodge_state: NpcsBaseState
@export_category("当前状态配置")
@export_group("变量配置")
##当前state是否属于战斗状态(玩家不可与me交互)
@export var on_combat:bool = false
@export var on_fighting:bool = false
##当前state启用npc的对player检测,比如寻敌
@export var enable_player_detection:bool
##当前state启用npc自身的检测
@export var enable_self:bool
##当前state启用npc的武器的碰撞检测		
@export var enable_weapon:bool
##当前state是否锁定player与可交互obj的交互		
@export var player_interact_lock:bool
@export_group("动画配置")
##当前状态是否要转换sprite
@export var change_animation:bool=true
@export var animation_name:String
@export var animation_backward:bool=false
##当前状态是否要颜色覆盖sprite
@export var change_sprite_color:bool=false
##要覆盖sprite的颜色
@export var sprite_color:Color
var aniplayer: AnimationPlayer
var npc:Npcs
var state_manager:NpcStateManager

##初始化事件
func init(all_states) -> void:
	load_all_state(all_states)
	connect_signal()
	
##根据名字载入所有状态
func load_all_state(all_states:Array):
	for state in all_states:
		var state_name =state.get_name()
		var prop_list = get_property_list()
		for i in prop_list.size():
			if i > 18:
				var prop_name:String = prop_list[i].name
				if prop_name.begins_with(state_name):
					set(prop_name,state)	

##进入该状态的方法，每次进入都会执行，在pre_physics_process之前进行
func pre_enter() -> bool:
	return true
	
func init_var():
	pass
	
##进入该状态的方法，每次进入都会执行，在pre_physics_process之前进行
func enter() -> NpcsBaseState:
	if change_animation:play_animation()
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
##播放动画		
func play_animation():
	var ani
	if animation_name:
		ani = animation_name
	else :
		ani = self.name
	if animation_backward:
		npc.aniplayer.play_backwards(ani)
	else :
		npc.aniplayer.play(ani)
##染色		
func change_animation_color(flag:bool=false):
	npc.base.material.set_shader_parameter("color",sprite_color)
	npc.base.material.set_shader_parameter("colored",flag)
	if flag:
		npc.aniplayer.pause()
	else:
		npc.aniplayer.play(npc.aniplayer.current_animation)

##判断玩家与当前npc的相对左右位置,右=1,左=-1	
func get_relative_position_x_2_player()->int:
	if PlayerState.player_global_position.x>=npc.global_position.x:
		return 1
	else:
		return -1
