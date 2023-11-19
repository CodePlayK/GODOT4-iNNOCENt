extends CombatState
@onready var dense_timer=$DenseTimer
@onready var dense_cooldown_timer=$DenseCooldownTimer
@export var dense_time:float = .5
@export var dense_cooldown:float = 1.4
@export var dense_gravity_scale:float = 12.0
@export_group("debug")
@export var densetimer_timeout:bool = false
func pre_enter() -> bool:
	if !PlayerState.ability_lock and PlayerState.denseable_flag:
		return true
	else:
		return false
		
func enter():
	super.enter()
	dense_timer.start(dense_time)
	dense_cooldown_timer.start(dense_cooldown)
	state_manager.attack_reset = false
	PlayerState.dense_flag=true
	PlayerState.denseable_flag=false
	player.max_velocity_y=player.max_velocity_y*dense_gravity_scale
	player.gravity=player.gravity*dense_gravity_scale
	return null	

func exit(state:BaseState):
	super.exit(state)
	state_manager.attack_reset = true
	dense_timer.stop()
	PlayerState.dense_flag=false
		
func _on_dense_timer_timeout():
	if densetimer_timeout:Debug.dprintwarn("[dense]计时结束切换上一状态")
	state_manager.state2state(PlayerState.get_last_normal_state(),self)
	
func _on_dense_cooldown_timer_timeout():
	PlayerState.denseable_flag=true
	player.max_velocity_y=player.max_velocity_y/dense_gravity_scale
	player.gravity=player.gravity/dense_gravity_scale

func on_hurt(area):
	if state_manager.current_state!=self:return
	if area.enable:
		state_manager.state2state(behitDenseSafed_state,self)
