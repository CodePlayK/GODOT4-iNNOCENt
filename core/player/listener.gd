extends Node
@onready var timer: Timer = $Timer
@onready var state_manager: PlayerStateManager = $".."
var to_state:BaseState
var from_state:BaseState
var trigger:Callable
var enable:bool

##在限定时间内判断某个动作为真,则会主动切换到某状态
func listen_to_state(to_state1:BaseState,trigger1:Callable,time:float,from_state1:BaseState):
	enable = true
	to_state = to_state1
	from_state = from_state1
	trigger = trigger1
	timer.start(time)
	state_manager.attack_reset = false#重置攻击状态
	
func input(event: InputEvent) -> bool:
	Debug.dprinterr("[监听]收到input")
	if !enable :return false
	if trigger.call(event):
		Debug.dprinterr("[监听]开始执行")
		if to_state:
			state_manager.state2state(to_state,to_state)
			enable = false
			to_state = null
			return true
		else :
			state_manager.attack_reset = true
	return false
	
func _on_timer_timeout() -> void:
	PlayerState.attacking = false
	reset()

func reset():
	enable = false
	state_manager.attack_reset = true	
	timer.stop()
	to_state = null
