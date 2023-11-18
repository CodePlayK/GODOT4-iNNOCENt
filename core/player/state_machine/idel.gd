extends BaseState


func enter():
	super.enter()
	PlayerState.double_jump_able=true
	return null
func input(event: InputEvent) -> BaseState:
	if event.is_action_pressed("jump") or event.is_action_pressed("light"):
		return jump_state
	elif event.is_action_pressed("dash"):
		return dash_state
	return null

func physics_process(delta: float) -> BaseState:
	move=get_movement_input_x()
	apply_gravity(delta)
	apply_acceleration_walk(move,delta)
	player_faced(move)
	player.set_up_direction(Vector2.UP)
	player.move_and_slide()
	if !player.is_on_floor():
		if player.velocity.y<=0:
			return lift_state
		else:
			return fall_state
	return null

func after_physics_process(delta: float) -> BaseState:
	if get_movement_input_x() and !is_player_blocked():
		if Input.is_action_pressed("run"):
			return run_state
		return walk_state
	return null
	
func exit(state:BaseState):
	super.exit(state)
