extends Node
@onready var timer: Timer = $Timer
@onready var state_manager: PlayerStateManager = $".."
@export_category("Debug")
@export var input_receive:bool = false
@export var input_receive_but_disable:bool = false
@export var input_receive_call_func_success:bool = false
@export var input_receive_call_func_fail:bool = false
var to_state:BaseState
var from_state:BaseState
var trigger:Callable
var enable:bool

##在限定时间内判断某个动作为真,则会主动切换到某状态
func listen_to_state(to_state1:BaseState,trigger1:Callable,time:float,from_state1:BaseState):
	to_state = to_state1
	from_state = from_state1
	trigger = trigger1
	timer.start(time)
	state_manager.attack_reset = false#重置攻击状态
	enable = true
	
func input(event: InputEvent) -> bool:
	if input_receive:Debug.dprinterr("[监听]收到input")
	if !enable :
		if input_receive_but_disable:Debug.dprinterr("[监听]enable=false")
		return false
	if trigger.call(event):
		if to_state:
			if input_receive_call_func_success:Debug.dprinterr("[监听]判断成功开始切换状态")
			state_manager.state2state(to_state,to_state)
			enable = false
			to_state = null
			return true
		else :
			if input_receive_call_func_fail:Debug.dprinterr("[监听]判断失败")
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
