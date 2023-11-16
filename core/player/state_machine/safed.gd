extends behit
@export var stiff_time=.3
@onready var stiff_timer= $"../StiffTimer"

func enter():
	super.enter()
	PlayerState.dense_success_flag=true
	#EventBus._play_SE("steel_clash")
	stiff_timer.start(stiff_time)

func _on_stiff_timer_timeout():
	if state_manager.current_state!=self:return
	state_manager.state2state(PlayerState.get_last_normal_state(),self)

func exit(state:BaseState):
	super.exit(state)
	stiff_timer.stop()
