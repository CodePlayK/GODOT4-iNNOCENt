extends InteractiveState

var was_on_air:bool =false

func exit(state:BaseState) -> void:
	PlayerState.double_jump_able=true
	if is_on_ladder():
		PlayerState.double_jump_able=false
	super.exit(state)


func physics_process(delta: float) -> BaseState:
	move=get_movement_input_x()
	player_faced(move)
	apply_acceleration_run(move,delta)
	was_on_air=!player.is_on_floor()
	if Input.is_action_pressed("jump"):
		player.velocity.y=-player.climb_speed
		player.velocity.x=player.climb_speed_x*move
	else:
		if player.velocity.y>0:
			return fall_state
		else:
			return lift_state
	apply_gravity(delta)
	player.set_up_direction(Vector2.UP)
	player.move_and_slide()
	if is_on_ladder():
		if player.is_on_floor():
			if  was_on_air:
				return landing_state
			else:
				if player.velocity.x==0:
					return idle_state
				else:
					return run_state
	else:
		if player.velocity.y>0:
			return fall_state
		else:
			return lift_state
	return null
