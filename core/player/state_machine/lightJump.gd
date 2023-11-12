extends BaseState

@onready var lightTimer=$lightTimer
@export var light_gravity_scale:float=3
@export var light_time:float = 3.0
@export var light_cooldown:float = 5.0
@onready var light_cooldown_timer: Timer = %lightCooldownTimer

func pre_enter() -> bool:
	if PlayerState.lightable_flag and !PlayerState.ability_lock:
		player.max_velocity_y=player.max_velocity_y/light_gravity_scale
		player.gravity=player.gravity/light_gravity_scale
		lightTimer.start(light_time)
		light_cooldown_timer.start(light_cooldown)
		PlayerState.lightable_flag=false
		PlayerState.light_flag=true
	return false
	
func enter():
	super.enter()
	
func exit(state:BaseState):
	super.exit(state)
	PlayerState.light_flag=true
	
func _on_light_timer_timeout():
	player.max_velocity_y=player.max_velocity_y*light_gravity_scale
	player.gravity=player.gravity*light_gravity_scale
	PlayerState.light_flag=false

func _on_light_cooldown_timer_timeout() -> void:
	PlayerState.lightable_flag=true
