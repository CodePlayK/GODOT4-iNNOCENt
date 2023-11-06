extends AirState


func process(delta: float) -> BaseState:
	if Input.is_action_just_pressed("jump"):
		return jump_state
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		if Input.is_action_pressed("run"):
			return run_state
		return walk_state
	return idle_state
