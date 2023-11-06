extends CanvasLayer
@onready var aniplayer =$"aniplayer"
@onready var color_rect = $ColorRect
@onready var color_rect_2 = $ColorRect2
@onready var color_rect_fade = $ColorRect_fade
@onready var screen_color = $ScreenColor


func _ready() -> void:
	EventBus.transition_show.connect(_on_transition_show)
	EventBus.change_transition_color.connect(_change_transition_color)
	self.hide()
	
func _on_transition_show(state,colored_flag=false):
	if colored_flag:
		await screen_color._get_screen_color()
		_change_transition_color(screen_color.screen_color.darkened(.5))
	EventBus.load_cutscene.emit()
	#Global.playing_transition=true
	self.show()
	match state:
		Global.transition_type.RIGHT_ENTER:
			aniplayer.play("right to left")
		Global.transition_type.RIGHT_LEFT:
			aniplayer.play_backwards("right to left")
		Global.transition_type.LEFT_ENTER:
			aniplayer.play("left to right")
		Global.transition_type.LEFT_LEFT:
			aniplayer.play_backwards("left to right")
		Global.transition_type.MID_ENTER:
			aniplayer.play("mid to side")
		Global.transition_type.MID_LEFT:
			aniplayer.play_backwards("mid to side")	
		Global.transition_type.FADE_OUT:
			aniplayer.play("fade out")
		Global.transition_type.FADE_IN:
			aniplayer.play_backwards("fade out")
	pass
func _on_aniplayer_animation_finished(anim_name: StringName) -> void:
	EventBus._unlock_doors()
	EventBus.transition_complete.emit()
	Global.playing_transition=false
	pass
func _change_transition_color(color:Color):
	color_rect.color=color
	color_rect_2.color=color
	color_rect_fade.color=color
