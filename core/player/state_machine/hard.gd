extends CombatState

@onready var dense_timer=$DenseTimer
@onready var dense_cooldown_timer=$DenseCooldownTimer

func pre_enter() -> bool:
	if !PlayerState.ability_lock and PlayerState.denseable_flag:
		return true
	else:
		return false
		
func enter():
	super.enter()
	PlayerState.dense_flag=true
	PlayerState.denseable_flag=false
	dense_timer.start()
	dense_cooldown_timer.start()
	return null	

func physics_process(delta: float):	
	if PlayerState.player_be_hitting:
		return behitDenseSafed_state

func exit(state:BaseState):
	super.exit(state)
	dense_timer.stop()
	PlayerState.dense_flag=false
	pass
		
func _on_dense_timer_timeout():
	state_manager.state2state(PlayerState.get_last_normal_state(),self)
func _on_dense_cooldown_timer_timeout():
	PlayerState.denseable_flag=true
	pass 
