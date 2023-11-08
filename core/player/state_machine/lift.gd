extends AirState
@export var toptrans_threshold:float = .1

func is_animation_play():
	if player.velocity.y <= 0 and !player.is_on_floor():
		return true
	return false

func enter():
	if player.velocity.y <= 0 and !player.is_on_floor():
		PlayerState.max_height = 0
	elif player.velocity.y > -player.max_velocity_y*toptrans_threshold and !player.is_on_floor():
		return toptrans_state
	elif player.is_on_floor():
		return idle_state
		
func input(event: InputEvent) -> BaseState:
	var new_state = super.input(event)
	if new_state:
		return new_state
	if Input.is_action_just_pressed("jump") and PlayerState.double_jump_able:
		PlayerState.double_jump_able=false
		return double_jump_state
	return null

func after_physics_process(delta: float)->BaseState:
	if player.is_on_floor():
		return landing_state
	else:
		if player.velocity.y > -player.max_velocity_y*toptrans_threshold:
			return toptrans_state
		elif player.velocity.y>0:
			return fall_state
	return null
