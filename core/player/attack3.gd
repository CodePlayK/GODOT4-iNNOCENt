extends PlayerAttackState

func pre_enter() -> bool:
	if PlayerState.attaking:
		return true
	else:
		return false
	
func _on_attack_timer_timeout() -> void:
	if to_next_attack:
		state_manager.state2state(attack2_state,self)
	else:
		PlayerState.attaking=false
		state_manager.state2state(PlayerState.get_last_normal_state(),self)
