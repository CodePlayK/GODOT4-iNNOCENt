extends PlayerAttackState
@onready var attack_timer: Timer = $attackTimer
@export var to_next_attack_threshold:float = .5

func pre_enter() -> bool:
	if PlayerState.attaking:
		return true
	else:
		return false
		
func input(event: InputEvent) -> BaseState:
	if event.is_action_pressed("attack"):
		if attack_timer.time_left>attack_timer.wait_time*to_next_attack_threshold:
			state_manager.to_attack2 = true
	return null		
	
func enter():
	super.enter()
	move = 0
	state_manager.to_attack1 = false
	attack_timer.start(aniplayer.get_animation("attack3").length/aniplayer.speed_scale)
	PlayerState.attaking=true
	EventBus._play_SE("slash1")
	aniplayer.play("attack3")
	await attack_timer.timeout

func exit(state:BaseState):
	super.exit(state)
	aniplayer.stop()
	player.weapon.monitorable = false

func _on_attack_timer_timeout() -> void:
	if state_manager.to_attack2:
		state_manager.state2state(attack2_state,self)
	else:
		PlayerState.attaking=false
		state_manager.state2state(PlayerState.get_last_normal_state(),self)
		#state_manager.state2state(idle_state,self)	
