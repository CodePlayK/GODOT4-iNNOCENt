extends GroundState

func enter():
	super.enter()
	EventBus._play_SE_LOOP("running-in-grass",true,.7)
	PlayerState.double_jump_able=true
	return null

func physics_process(delta: float) -> BaseState:
	move = get_movement_input_x()
	if player.is_on_floor() :
		if Input.is_action_pressed("run"):
			if PlayerState.is_player_on_fighting:
				return fastrun_state
			else :
				return run_state
	if !player.is_on_floor() and player.velocity.y<=0:
		return lift_state
	if player.velocity.y>0:
		return fall_state
	player_faced(move)
	apply_gravity(delta)
	if move==0 or is_player_change_moving_direction():
		apply_friction(delta)
	else:
		apply_acceleration_walk(move,delta)
	player.set_velocity(player.velocity)
	player.set_up_direction(Vector2.UP)
	player.move_and_slide()
	min_jump_force(player.velocity,delta)
	if player.velocity.x==0 and move==0:
		return idle_state
	return null
	
func exit(state:BaseState):
	super.exit(state)
	EventBus._play_SE_LOOP("running-in-grass",false)



