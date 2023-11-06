extends CutsceneBaseState
@export var resource:DialogueResource

func enter():
	aniplayer=$aniplayer
	pass
	
func play_cutscene():
	await cutscene_started()
	await scene_0_0_0()
	await cutscene_finished()
	EventBus._change_cutscene("0_1_0")
	

func scene_0_0_0():
	#await play_and_wait("0_0_0")
	await EventBus._move_2_player(Npc.SEN)
	await wait(.5)
	await talk_and_wait(Npc.SEN,resource,"C0_0_0_醒来",1)
	
func cutscene_finished():
	EventBus._player_control_lock(false)
	Global.lock_room_doors()
	CutsceneState.cutscene_playing=false
	PlayerState.enable_all_ineractable()
			
func cutscene_started():
	Global.lock_room_doors()
	PlayerState.disable_all_ineractable()
	EventBus._player_control_lock(true)
	await wait(.5)
	
func trans_position_to_marker(npc:Node2D,to_position:Marker2D):
	npc.position.x=to_position.position.x

func _on_timer_timeout() -> void:
	EventBus._change_ifrit_emoji("question_mark",3.0,"top")
	pass 
