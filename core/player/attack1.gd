extends CombatState

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

func physics_process(delta: float):	
		return null

func exit(state:BaseState):
	super.exit(state)
	PlayerState.attaking=false
	aniplayer.stop()
	pass
	
