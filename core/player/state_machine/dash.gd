extends GroundState

@onready var timer: Timer = $Timer
@export_range(0,5.0) var dash_cooldown:float = 1.0
@export var dash_time:float = 1
var current_dash_time: float = 0
var enable:bool = true

func pre_enter() -> bool:
	return enable
	
func enter():
	super.enter()
	timer.start(dash_cooldown)
	EventBus._play_SE("lazer",1,-15)
	enable = false
	player.hurt_box.disable_hit()
	current_dash_time = dash_time
	return null

func input(event: InputEvent) -> BaseState:
	if Input.is_action_pressed("jump") and player.is_on_floor():
		return jump_state
	if current_dash_time > 0:
		return null
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		if Input.is_action_pressed("run"):
			return run_state
		return walk_state
	return null

func physics_process(delta: float) -> BaseState:
	current_dash_time -= delta
	player_faced(PlayerState.face_left_normalize)
	apply_gravity(delta)
	apply_acceleration_dash(PlayerState.face_left_normalize,delta)
	player.set_velocity(player.velocity)
	player.set_up_direction(Vector2.UP)
	player.move_and_slide()
	if current_dash_time<=0:
		return PlayerState.get_last_normal_state()
	#if  player.velocity.x==0:
		#return idle_state
	return null

func exit(state:BaseState):
	super.exit(state)
	player.velocity.x = 0
	player.hurt_box.enable_hit()
	

func _on_timer_timeout() -> void:
	enable = true
