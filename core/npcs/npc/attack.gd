extends NpcsBaseState
##玩家攻击状态
class_name NpcsAttackState
##下一段攻击
@export_category("配置")
@export_group("伤害")
@export var damage:float = 1.0
@export_group("基础配置")
@export var next_attack:NpcsAttackState
##在经过攻击时长多少比例后,可以切换到下一攻击
@export_range(0,1.0) var to_next_attack_threshold:float = .2
##攻击后的硬直时间
@export_range(0,5.0) var after_attack_stiff_time:float = .5
##攻击后可以切换到下一段攻击的时间
@export_range(0,2.0) var listen_next_attack_time:float = 1
##攻击动画名,默认为状态名
@export var ani_name:String
##声音
@export var sound_name:String = "slash7"
@export_group("运动配置")
##攻击状态中是否允许移动
@export var moveable:bool = true
@export var change_face_able:bool = true
##攻击状态中的移动速度比率:相对于行走速度
@export_range(0,2.0) var move_speed_scale_to_walk:float = 1.0
##实际的攻击动画耗时,包括僵直
@onready var attack_timer: Timer = $attackTimer
##到下一段攻击
var to_next_attack:bool = false

func connect_signal():
	if attack_timer:
		attack_timer.timeout.connect(_on_attack_timer_timeout)

func init_var():
	if !ani_name:
		ani_name = self.name

func enter():
	npc.hit_box.disable_shape()
	npc.hit_box.damage = damage
	super.enter()
	to_next_attack = false
	attack_timer.start(aniplayer.get_animation(ani_name).length/aniplayer.speed_scale+after_attack_stiff_time)
	npc.attacking=true
	aniplayer.play(ani_name)

func physics_process(delta: float) -> NpcsBaseState:
	if (PlayerState.dense_flag or PlayerState.dense_success_flag) and npc.hit_box.has_overlapping_areas():
		return behithard_state
	return null
	
func exit(state:NpcsBaseState):
	super.exit(state)
	aniplayer.stop()
	for c in sound_config:
		stop_sound(c.se_name)
	npc.hit_box.disable_shape()
	npc.hit_box.damage = 0
	attack_timer.stop()
	#当没有执行切换到下一段攻击,且有配置下一段攻击,或者退出的下一个状态不是攻击状态时
	if !to_next_attack and next_attack or !state is NpcsAttackState:
		state_manager.attack_reset = false
	#如果没有配置下一段攻击,且没有执行切换下一段,重置攻击
	elif !to_next_attack  and !next_attack:
		state_manager.attack_reset = true
		npc.attacking = false

##攻击动画结束,包括僵直		
func _on_attack_timer_timeout() -> void:
	#正在攻击动画中按下且有下一段攻击时则直接切换
	if to_next_attack and next_attack:
		state_manager.state2state(next_attack)
	else:#否则为结束攻击,切换到上一个正常状态,重置攻击状态
		state_manager.state2state(state_manager.get_last_normal_state())	
		npc.attacking=false
		state_manager.attack_reset = true
	
