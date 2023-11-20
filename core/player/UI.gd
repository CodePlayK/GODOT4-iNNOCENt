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
@onready var damage_num: Node2D = $HurtFX/DamageNum
@onready var health_bar: UIbar = $HealthBar

@onready var fighting_delay_timer: Timer = $FightingDelayTimer
@export var fighting_off_delay_time:float
@export var health_bar_back_delay_time:float
@export var health_bar_back_delay_tween_time:float = .5

func _ready():
	dense_cooldown_bar.max_value=dense_cooldown_timer.wait_time
	light_bar.max_value=light_timer.wait_time
	light_cooldown_bar.max_value=light_cooldown_timer.wait_time
	stiff_bar.max_value=stiff_timer.wait_time
	health_bar.bar_max_value = PlayerState.max_health

func _process(delta):
	dense_cooldown_bar.value=dense_cooldown_timer.time_left
	light_bar.value=light_timer.time_left
	light_cooldown_bar.value=light_cooldown_timer.time_left
	stiff_bar.value=stiff_timer.time_left

func player_on_fighting_changed(f:bool):
	if f:
		fighting_delay_timer.stop()
		health_bar.show()
	else :
		fighting_delay_timer.start(fighting_off_delay_time)
		

func _on_fighting_delay_timer_timeout() -> void:
	health_bar.hide()


##血量改变时
func on_health_damaged() -> void:
	health_bar.bar_decrease(PlayerState.health)
	if PlayerState.last_health > PlayerState.health:
		damage_num.emit_num(PlayerState.last_health-PlayerState.health)
func on_health_healed():
	health_bar.bar_grow(PlayerState.health)
func on_stamina_damaged():
	EventBus._player_stamina_damaged()	
func on_stamina_recovered():
	EventBus._player_stamina_recovered()	
