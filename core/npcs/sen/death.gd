extends NpcsCombatState

func enter():
	super.enter()
	await get_tree().create_timer(npc.aniplayer.current_animation_length).timeout
	npc.hide()
	npc.queue_free()
