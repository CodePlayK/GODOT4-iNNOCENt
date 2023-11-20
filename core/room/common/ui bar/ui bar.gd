extends ProgressBar
class_name UIbar
@export var bar_max_value:float
@export var bar_min_value:float
@export var back_bar_delay_time:float
@export var current_value:float
var last_value:float
@onready var back_bar_timer: Timer = $BackBarTimer
@onready var back_bar: ProgressBar = $UIBarBack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_changed():
	var health_bar_tween = self.create_tween() 
	health_bar_tween.set_trans(Tween.TRANS_CUBIC)
	health_bar_tween.set_ease(Tween.EASE_OUT)
	health_bar_tween.tween_property(self,"value",current_value,.2)
	await health_bar_tween.finished
	health_bar_tween.kill()
	if back_bar_timer.is_stopped():
		back_bar.value = last_value
		back_bar_timer.start(back_bar_delay_time)
