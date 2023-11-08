extends behit
@onready var stiff_timer= $"../StiffTimer"
@export var stiff_time=.3

func enter():
	super.enter()
	player.hitbox.monitoring=false
	EventBus._play_SE("be_hit_by_body")
	stiff_timer.start(stiff_time)
	return null

func _on_stiff_timer_timeout():
	if state_manager.current_state!=self:return
	player.hitbox.monitoring=true
	state_manager.state2state(PlayerState.get_last_normal_state(),self)
	
func exit(state:BaseState):
	super.exit(state)
	stiff_timer.stop()
