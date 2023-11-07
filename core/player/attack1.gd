extends CombatState
@onready var attack_timer: Timer = $attackTimer

func pre_enter() -> bool:
	if !PlayerState.attaking:
		return true
	else:
		return false
		
func enter():
	super.enter()
	PlayerState.attaking=true
	EventBus._play_SE("slash7")
	aniplayer.play("attack0")
	await aniplayer.animation_finished
	return PlayerState.get_last_normal_state()	

func exit(state:BaseState):
	super.exit(state)
	aniplayer.stop()
	player.weapon.monitorable = false
	attack_timer.start(aniplayer.current_animation.length())

func _on_attack_timer_timeout() -> void:
	PlayerState.attaking=false
