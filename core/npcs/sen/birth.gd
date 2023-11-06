extends NpcsCombatState
func enter():
	npc.set_visible(true)
	super.enter()
	await npc.base.animation_finished
	return patrol_state
