class_name PlayerInteractiveObj extends Node
@onready var dialogue_position: Marker2D = $DialoguePosition

var obj_name:String:
	set(s):
		obj_name=str(s.replace("_","")).to_lower()
var on_talk:bool

func _ready() -> void:
	EventBus.cutscene_finished.connect(on_cutscene_finished)
	EventBus.cutscene_is_playing.connect(on_cutscene_is_playing)
	if Global.playing_transition:return
func _physics_process(delta: float) -> void:
	if Global.playing_transition:return
	
func _unhandled_input(event: InputEvent) -> void:
	if Global.playing_transition:return

func _process(delta: float) -> void:
	if Global.playing_transition:return
	
func on_cutscene_finished():
	on_talk=false
	
func on_cutscene_is_playing():
	pass
