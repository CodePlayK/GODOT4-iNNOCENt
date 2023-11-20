extends StackingState
@export var bati_onhit_color_time:float = .2
@onready var timer: Timer = $Timer

func enter():
	timer.start(bati_onhit_color_time)
	PlayerState.damage_health(state_manager.current_damage)

func _on_timer_timeout() -> void:
	change_animation_color(false,false)
