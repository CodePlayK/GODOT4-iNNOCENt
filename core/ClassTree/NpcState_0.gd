extends NpcBaseState
class_name NpcState_0
var dialogue_interactive:Resource
var dialogue_cutscene:Resource

func init():
	super.init()
	load_dialogue()

func load_dialogue():
	dialogue_interactive=preload("res://core/common/dialogue_ballon/dialogue/interactive_all.dialogue")
	dialogue_cutscene=preload("res://core/common/dialogue_ballon/dialogue/0_0_bedroom.dialogue")
