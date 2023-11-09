extends Node
@onready var timer: Timer = $Timer
@onready var state_manager: PlayerStateManager = $".."

var to_state:BaseState
var trigger:Callable
var enable:bool

func listen_to_state(to_state1:BaseState,trigger1:Callable,time:float):
	to_state = to_state1
	trigger = trigger1
	timer.start(time)
	state_manager.attack_reset = false	
	enable = true
	
func input(event: InputEvent) -> bool:
	if !enable and !PlayerState.attaking:return false
	if trigger.call(event):
		print("监听切换到[%s]",to_state)
		if to_state:
			state_manager.state2state(to_state,to_state)
			reset()
			return true
		else :
			state_manager.attack_reset = true
	return false
	
func _on_timer_timeout() -> void:
	PlayerState.attaking = false
	reset()

func reset():
	enable = false
	state_manager.attack_reset = true	
	timer.stop()
	to_state = null
