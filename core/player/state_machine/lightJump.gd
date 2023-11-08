extends BaseState

@onready var lightTimer=$lightTimer
@export var i:float=3

func pre_enter() -> bool:
	if PlayerState.lightable_flag and !PlayerState.ability_lock:
		player.max_velocity_y=player.max_velocity_y/i
		player.gravity=player.gravity/i
		lightTimer.start()
		PlayerState.lightable_flag=false
		PlayerState.light_flag=true
	return false
	
func enter():
	super.enter()
	
func exit(state:BaseState):
	super.exit(state)
	PlayerState.light_flag=true
	
func _on_light_timer_timeout():
	player.max_velocity_y=player.max_velocity_y*i
	player.gravity=player.gravity*i
	PlayerState.light_flag=false
	PlayerState.lightable_flag=true
