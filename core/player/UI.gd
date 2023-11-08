extends Node
@onready var player=$".."
@onready var dense_cooldown_timer=%DenseCooldownTimer
@onready var light_timer=%lightTimer
@onready var dense_cooldown_bar=$DenseCooldownBar
@onready var light_bar=$LightBar
@onready var stiff_timer=%StiffTimer
@onready var stiff_bar=$StiffBar
@onready var tl_2: Label = %TL2
@onready var health_bar: ProgressBar = $HealthBar

func _ready():
	dense_cooldown_bar.max_value=dense_cooldown_timer.wait_time
	light_bar.max_value=light_timer.wait_time
	stiff_bar.max_value=stiff_timer.wait_time

func _process(delta):
	dense_cooldown_bar.value=dense_cooldown_timer.time_left
	light_bar.value=light_timer.time_left
	stiff_bar.value=stiff_timer.time_left

func _on_timer_timeout() -> void:
	tl_2.text=str(int(tl_2.text)+1)
