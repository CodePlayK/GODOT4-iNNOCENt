extends Node2D
@onready var test_label: Label = %TestLabel
@onready var running_time: Label = %RunningTime
@onready var timer: Timer = $RunningTime/Timer

func _on_timer_timeout() -> void:
	running_time.text=str(int(running_time.text)+1)
