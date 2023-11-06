extends GroundState

@export var dash_time:float = 1
var current_dash_time: float = 0
var dash_direction: int = 0

func enter():
	super.enter()
	current_dash_time = dash_time
	return null

func input(event: InputEvent) -> BaseState:
	if Input.is_action_pressed("jump"):
		return jump_state
	if current_dash_time > 0:
		return null
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		if Input.is_action_pressed("run"):
			return run_state
		return walk_state
	return null

# Track how long we've been dashing so we know when to exit
func physics_process(delta: float) -> BaseState:
	current_dash_time -= delta
	dash_direction=get_player_faced_direction()
	if !player.is_on_floor() and player.velocity.y<=0:
		return lift_state
	if player.velocity.y>0:
		return fall_state
	player_faced(dash_direction)
	apply_gravity(delta)
	apply_acceleration_run(dash_direction,delta)
	player.set_velocity(player.velocity)
	player.set_up_direction(Vector2.UP)
	player.move_and_slide()
	if current_dash_time<=0:
		return walk_state
	if  player.velocity.x==0:
		return idle_state
	return null
