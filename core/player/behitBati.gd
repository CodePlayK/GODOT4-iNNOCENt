extends BehitDamagedState

func _on_protect_timer_timeout() -> void:
	if state_manager.current_state!=self:return
	state_manager.state2state(PlayerState.last_state,self)
