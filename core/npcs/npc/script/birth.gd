extends NpcsCombatState
func enter():
	npc.set_visible(true)
	super.enter()
	await npc.aniplayer.animation_finished
	return patrol_state
