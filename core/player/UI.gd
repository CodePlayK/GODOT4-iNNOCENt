extends Node
@onready var player=$".."
@onready var dense_cooldown_timer=%DenseCooldownTimer
@onready var dense_cooldown_bar=$DenseCooldownBar
@onready var light_bar=$LightBar
@onready var light_cooldown_bar: ProgressBar = $LightBar/LightCooldownBar
@onready var light_timer=%lightTimer
@onready var light_cooldown_timer: Timer = %lightCooldownTimer
@onready var stiff_timer=%StiffTimer
@onready var stiff_bar=$StiffBar
@onready var health_bar: ProgressBar = $HealthBar
@onready var health_bar_back: ProgressBar = $HealthBar/HealthBarBack
@onready var health_bar_back_timer: Timer = $HealthBarBackTimer

@onready var fighting_delay_timer: Timer = $FightingDelayTimer
@export var fighting_off_delay_time:float
@export var health_bar_back_delay_time:float
@export var health_bar_back_delay_tween_time:float = .5

func _ready():
	dense_cooldown_bar.max_value=dense_cooldown_timer.wait_time
	light_bar.max_value=light_timer.wait_time
	light_cooldown_bar.max_value=light_cooldown_timer.wait_time
	stiff_bar.max_value=stiff_timer.wait_time

func _process(delta):
	dense_cooldown_bar.value=dense_cooldown_timer.time_left
	light_bar.value=light_timer.time_left
	light_cooldown_bar.value=light_cooldown_timer.time_left
	stiff_bar.value=stiff_timer.time_left

func player_on_fighting_changed(f:bool):
	if f:
		fighting_delay_timer.stop()
		health_bar.show()
		health_bar_back.show()
	else :
		fighting_delay_timer.start(fighting_off_delay_time)

func _on_fighting_delay_timer_timeout() -> void:
	health_bar.hide()
	health_bar_back.hide()

func on_health_changed() -> void:
	var health_bar_tween = health_bar.create_tween() 
	health_bar_tween.set_trans(Tween.TRANS_CUBIC)
	health_bar_tween.set_ease(Tween.EASE_OUT)
	health_bar_tween.tween_property(health_bar,"value",PlayerState.health,.2)
	await health_bar_tween.finished
	health_bar_tween.kill()
	if health_bar_back_timer.is_stopped():
		player.ui.health_bar_back.value = PlayerState.last_health
		health_bar_back_timer.start(health_bar_back_delay_time)
	
func _on_health_bar_back_timer_timeout() -> void:
	var health_bar_back_tween = health_bar_back.create_tween() 
	health_bar_back_tween.set_trans(Tween.TRANS_CUBIC)
	health_bar_back_tween.set_ease(Tween.EASE_OUT)
	health_bar_back_tween.tween_property(health_bar_back,"value",PlayerState.health,health_bar_back_delay_tween_time)
	await health_bar_back_tween.finished
	health_bar_back_tween.kill()
