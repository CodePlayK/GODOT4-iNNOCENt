extends NpcBehitState

func connect_signal():
	state_manager.hitbox.area_entered.connect(on_hit)
	
func on_hit(area:Area2D):
	if state_manager.current_state != self:
		return
	EventBus._play_SE("knife-stab")
	npc.life -= 1
	print(npc.life)
	if npc.life<=0:
		state_manager.state2state(death_state)