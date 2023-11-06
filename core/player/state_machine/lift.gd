extends AirState

func input(event: InputEvent) -> BaseState:
	var new_state = super.input(event)
	if new_state:
		return new_state
	if Input.is_action_just_pressed("jump") and Global.double_jump_flag:
		Global.double_jump_flag=false
		return double_jump_state
	return null
