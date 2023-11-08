extends BaseState
class_name PlayerAttackState
@export var next_attack:PlayerAttackState
var next_able:bool = false

func physics_process(delta: float) -> BaseState:
	move = get_movement_input_x()
	player_faced(move)
	apply_gravity(delta)
	if move==0 or is_player_change_moving_direction() or player.is_on_floor():
		apply_friction(delta)
	else:
		if Input.is_action_pressed("run"):
			apply_acceleration_run(move,delta)
		else:
			apply_acceleration_walk(move,delta)
	player.set_velocity(player.velocity)
	player.set_up_direction(Vector2.UP)
	player.move_and_slide()
	min_jump_force(player.velocity,delta)
	return null
