class_name GroundState
extends BaseState


var edge_jump_flag=true
func enter():
	super.enter()
	Global.double_jump_flag=true
	return null

func input(event: InputEvent) -> BaseState:
	if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("light"):
		return jump_state
	if Input.is_action_just_pressed("dash"):
		return dash_state
	if player.is_on_floor() :
		if Input.is_action_pressed("run"):
			if PlayerState.is_player_on_fighting:
				return fastrun_state
			else :
				return run_state
		if get_palyer_move_direction_x()!=0:
			return walk_state
		else:
			return null
	if is_on_ladder() and Input.is_action_pressed("jump"):
		return climb_state
	return null

func pre_physics_process(delta:float)-> BaseState:
	return null

func physics_process(delta: float) -> BaseState:
	move = get_movement_input_x()
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
	if player.velocity.x==0:
		return idle_state
	return null

func exit(state:BaseState):
	super.exit(state)
	pass


