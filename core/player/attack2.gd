extends PlayerAttackState
@onready var attack_timer: Timer = $attackTimer
func pre_enter() -> bool:
	if PlayerState.attaking:
		return true
	else:
		return false
		
func enter():
	super.enter()
	move = 0
	state_manager.to_attack2 = false
	attack_timer.start(aniplayer.get_animation("attack2").length/aniplayer.speed_scale)
	PlayerState.attaking=true
	EventBus._play_SE("slash4")
	aniplayer.play("attack2")
	await attack_timer.timeout

func exit(state:BaseState):
	super.exit(state)
	aniplayer.stop()
	player.weapon.monitorable = false

func _on_attack_timer_timeout() -> void:	
	PlayerState.attaking=false
	state_manager.state2state(PlayerState.get_last_normal_state(),self)
