extends PlayerAttackState
@onready var attack_timer: Timer = $attackTimer
@export var to_next_attack_threshold:float = .5

func pre_enter() -> bool:
	if !PlayerState.attaking:
		return true
	else:
		return false
		
func input(event: InputEvent) -> BaseState:
	if event.is_action_pressed("attack"):
		if attack_timer.time_left>attack_timer.wait_time*to_next_attack_threshold:
			state_manager.to_attack1 = true
	return null		
	
func enter():
	super.enter()
	move = 0
	attack_timer.start(aniplayer.get_animation("attack0").length/aniplayer.speed_scale)
	PlayerState.attaking=true
	EventBus._play_SE("slash7")
	aniplayer.play("attack0")

func exit(state:BaseState):
	super.exit(state)
	aniplayer.stop()
	player.weapon.monitorable = false

func _on_attack_timer_timeout() -> void:
	if state_manager.to_attack1:
		state_manager.state2state(attack1_state,self)
	else:
		PlayerState.attaking=false
		state_manager.state2state(PlayerState.get_last_normal_state(),self)	
		#state_manager.state2state(idle_state,self)	
	
