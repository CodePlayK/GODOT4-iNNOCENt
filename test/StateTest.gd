extends Label
@onready var npc_state_manager: Node = $"../NpcStateManager"


func _on_timer_timeout() -> void:
	if npc_state_manager.change_state_now and npc_state_manager.test_state:
		npc_state_manager.change_state(npc_state_manager.test_state)
