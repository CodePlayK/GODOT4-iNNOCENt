extends Area2D
@onready var aniplayer=$AnimationPlayer
@onready var timer= $Timer
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	PlayerState.player_be_hitting=true
	timer.start()
	aniplayer.pause()
	pass 


func _on_timer_timeout():
	aniplayer.play("test1")
	pass 
