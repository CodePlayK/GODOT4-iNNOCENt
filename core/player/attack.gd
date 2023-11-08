extends BaseState
class_name PlayerAttackState
@export var next_attack:PlayerAttackState
@export var to_next_attack_threshold:float = .5
@export var ani_name:String
@export var sound_name:String = "slash7"
@onready var attack_timer: Timer = $attackTimer
var to_next_attack:bool = false

func init_var():
	ani_name = self.name

func input(event: InputEvent) -> BaseState:
	if event.is_action_pressed("attack"):
		if attack_timer.time_left>attack_timer.wait_time*to_next_attack_threshold:
			to_next_attack = true
	return null		

func enter():
	super.enter()
	to_next_attack = false
	move = 0
	attack_timer.start(aniplayer.get_animation(ani_name).length/aniplayer.speed_scale)
	PlayerState.attaking=true
	EventBus._play_SE(sound_name)
	aniplayer.play(ani_name)

func physics_process(delta: float) -> BaseState:
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
	player.weapon.monitorable = false
