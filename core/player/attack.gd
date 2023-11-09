extends BaseState
##玩家攻击状态
class_name PlayerAttackState
##下一段攻击
@export var next_attack:PlayerAttackState
##在经过攻击时长多少比例后,可以切换到下一攻击
@export_range(0,1.0) var to_next_attack_threshold:float = .2
@export_range(0,5.0) var after_attack_stiff_time:float = .5
@export_range(0,2.0) var listen_next_attack_time:float = 1
##攻击动画名,默认为状态名
@export var ani_name:String
##声音
@export var sound_name:String = "slash7"
@onready var attack_timer: Timer = $attackTimer
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
	return null		

func enter():
	super.enter()
	to_next_attack = false
	move = 0
	attack_timer.start(aniplayer.get_animation(ani_name).length/aniplayer.speed_scale+after_attack_stiff_time)
	PlayerState.attaking=true
	EventBus._play_SE(sound_name)
	aniplayer.play(ani_name)

func physics_process(delta: float) -> BaseState:
	if player.is_on_floor() and Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("light"):
		player.set_up_direction(Vector2.UP)
		player.velocity.y = -player.jump_speed
	move = get_movement_input_x()
	player_faced(move)
	apply_gravity(delta)
	if move==0 or is_player_change_moving_direction() or player.is_on_floor():
		apply_friction(delta)
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
	aniplayer.stop()
	attack_timer.stop()
	player.weapon.monitorable = false
	if !to_next_attack and next_attack or !state is PlayerAttackState:
		state_manager.attack_reset = false
		state_manager.listener.listen_to_state(next_attack,listen_next_attck,listen_next_attack_time)
	elif !to_next_attack  and !next_attack:
		state_manager.attack_reset = true
		PlayerState.attaking = false
		
func listen_next_attck(event):
	if event.is_action_pressed("attack"):
		return true
		
func _on_attack_timer_timeout() -> void:
	if state_manager.current_state in [dense_state]:
		return
	if to_next_attack and next_attack:
		state_manager.state2state(next_attack,self)
	else:
		state_manager.state2state(PlayerState.get_last_normal_state(),self)	
		PlayerState.attaking=false
		state_manager.attack_reset = true
	
