extends InteractiveState
var first_touch_floor=false

func enter():
	super.enter()
	first_touch_floor=false
	Global.double_jump_flag=true
	PlayerState.player_control_lcok=true
	return null
func input(event: InputEvent) -> BaseState:
	return null

func physics_process(delta: float) -> BaseState:
	if first_touch_floor:return null
	player.velocity.x=0
	apply_gravity(delta)
	player_faced(move)
	player.set_up_direction(Vector2.UP)
	player.move_and_slide()
	if player.is_on_floor():
		first_touch_floor=true
		EventBus.emit_signal("player_control_locked")
	return null 

func after_physics_process(delta: float) -> BaseState:
	return null
func exit(state:BaseState):
	super.exit(state)
	PlayerState.player_control_lcok=false
	pass
