extends NpcsCombatState

func enter():
	super.enter()
	await npc.base.animation_finished
	npc.queue_free()
	pass
