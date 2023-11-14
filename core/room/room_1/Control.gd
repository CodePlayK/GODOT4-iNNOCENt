extends Control
#@onready var npc_an: Area2D = %Npc_An
#@onready var npc_sen: NpcSen = %Npc_Sen
@onready var npcs: Node2D = $"../../Parallax/ParallaxLayer_5/Npcs"

@onready var marker_2: Marker = $"../../Parallax/ParallaxLayer_5/Marker/CutsceneCameraMarker/Marker2"
@onready var marker_3: Marker = $"../../Parallax/ParallaxLayer_5/Marker/CutsceneCameraMarker/Marker3"
@onready var marker: Marker = $"../../Parallax/ParallaxLayer_5/Marker/CutsceneCameraMarker/Marker"
@onready var portrol_right_marker: Marker = $"../../Parallax/ParallaxLayer_5/Marker/PortrolRightMarker"
@onready var portrol_left_marker: Marker = $"../../Parallax/ParallaxLayer_5/Marker/PortrolLeftMarker"
@onready var timer: Timer = $"../../Parallax/ParallaxLayer_5/Test/Timer"


func _on_button_2_button_down():
	EventBus._move_2_player(Npc.AN,2)
	pass 


func _on_button_4_button_down():
	pass 

func _on_button_5_pressed():
	EventBus._cutscene_play()
	pass 

func _on_button_pressed():
	EventBus._move_2_player(Npc.SEN,2)
	pass 

func _on_button_3_pressed():
	EventBus._to_title_screen()
	pass 


func _on_button_5_button_down():
	EventBus._transition_show(Global.transition_type.RIGHT_LEFT)
	await EventBus.transition_complete
	EventBus._change_room(Global.rooms.ROOM_2)
	pass 


func _on_title_screen_pressed():
	EventBus._to_title_screen()
	pass 


func _on_button_3_button_down():
	EventBus._to_title_screen()
	pass 


func _on_button_6_button_down():
	EventBus._transition_show(Global.transition_type.LEFT_LEFT)
	await EventBus.transition_complete
	EventBus._change_room(Global.rooms.ROOM_1)
	pass 


func _on_cutscene_camera_toggled(toggled_on: bool) -> void:
	if toggled_on:
		var dic={
			marker:3,
			marker_2:5,
			marker_3:3
		}
		EventBus._cutscene_camera(dic)
	else:
		EventBus._cutscene_camera_reset()
	pass 


func _on_play_cutscene_button_down() -> void:
	CutscenerGlobal.cutscener_run.emit("NA")

func _on_enemy_toggled(toggled_on: bool) -> void:
	if toggled_on:
		timer.start()
	else:
		timer.stop()
