extends NpcsCombatState

func enter():
	super.enter()
	await get_tree().create_timer(npc.base.animation.length()).timeout
	npc.hide()
	npc.queue_free()
