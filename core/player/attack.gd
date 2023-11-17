extends BaseState
##玩家攻击状态
class_name PlayerAttackState
##下一段攻击
@export_category("配置")
@export_group("伤害")
@export var damage:float = 1.0
@export_group("基础配置")
@export var next_attack:PlayerAttackState
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

func _ready() -> void:
	if attack_timer:
		attack_timer.timeout.connect(_on_attack_timer_timeout)

func init_var():
	if !ani_name:
		ani_name = self.name

func input(event: InputEvent) -> BaseState:
	if event.is_action_pressed("attack"):
		if attack_timer.time_left>(attack_timer.wait_time+after_attack_stiff_time)*to_next_attack_threshold:
			to_next_attack = true
	if moveable:
		if player.is_on_floor() and(Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("light")):
			player.set_up_direction(Vector2.UP)
			player.velocity.y = -player.jump_speed
		move = get_movement_input_x()
	return null		

func enter():
	player.hit_box.disable_shape()
	player.hit_box.damage = damage
	super.enter()
	to_next_attack = false
	state_manager.attack_reset = false
	move = 0
	attack_timer.start(anime.current_animation_length+after_attack_stiff_time)
	PlayerState.attacking=true
	PlayerState.hitting=true

func physics_process(delta: float) -> BaseState:
	if change_face_able:
		player_faced(move)	
	apply_gravity(delta)
	if move==0 or is_player_change_moving_direction() :
		apply_friction(delta)
	elif player.is_on_floor():
		apply_acceleration_custom(move,move_speed_scale_to_walk,delta)
	else:
		if Input.is_action_pressed("run"):
			apply_acceleration_run(move,delta)
		else:
			apply_acceleration_walk(move,delta)
	player.set_velocity(player.velocity)
	player.set_up_direction(Vector2.UP)
	player.move_and_slide()
	min_jump_force(player.velocity,delta)
	return null
	
func exit(state:BaseState):
	super.exit(state)
	player.hit_box.disable_shape()
	player.hit_box.damage = 0
	attack_timer.stop()
	PlayerState.hitting=false
	#当没有执行切换到下一段攻击,且有配置下一段攻击,或者退出的下一个状态不是攻击状态时
	#开启监听
	if !to_next_attack and next_attack or !state is PlayerAttackState:
		state_manager.listener.listen_to_state(next_attack,listen_next_attck,listen_next_attack_time,self)
	#如果没有配置下一段攻击,且没有执行切换下一段,重置攻击
	elif !to_next_attack  and !next_attack:
		state_manager.attack_reset = true
		PlayerState.attacking = false
		
##是否在攻击动画结束后,且在listener中监听结束前按下攻击		
func listen_next_attck(event):
	if event.is_action_pressed("attack"):
		return true

##攻击动画结束,包括僵直		
func _on_attack_timer_timeout() -> void:
	#如果当前处于硬化状态则跳过
	if state_manager.current_state in [dense_state]:
		return
	#正在攻击动画中按下且有下一段攻击时则直接切换
	if to_next_attack and next_attack:
		state_manager.state2state(next_attack,self)
	else:#否则为结束攻击,切换到上一个正常状态,重置攻击状态
		state_manager.state2state(PlayerState.get_last_normal_state(),self)	
		state_manager.attack_reset = true
		PlayerState.attacking = false
