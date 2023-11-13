extends NpcsCombatState
@onready var timer: Timer = $Timer

func enter():
	super.enter()
	aniplayer.play("dodge")
	timer.start(aniplayer.get_animation("dodge").length)

func _on_timer_timeout() -> void:
	state_manager.state2state(chase_state)
	pass # Replace with function body.
