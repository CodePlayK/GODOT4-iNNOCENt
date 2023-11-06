extends NpcAn_0


func input(event: InputEvent) -> NpcBaseState:
	if get_on_player():
		pass
	return null

func on_player_talk():

	talk(dialogue_interactive,"test1")
