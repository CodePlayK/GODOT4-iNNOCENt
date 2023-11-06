extends Node
class_name CutsceneBaseState

var current_state:CutsceneBaseState
@onready var aniplayer
func init() -> void:
	pass
#进入该状态的方法，每次进入都会执行，在pre_physics_process之前进行
func enter() -> void:
	pass
	
func play_cutscene():
	pass
#退出该状态的方法，每次进入都会执行，在physics_process之后进行
func exit():
	pass
	
func wait(time):
	await get_tree().create_timer(time).timeout
	
func trans_npc_position(npc:Node2D,to_position):
	npc.global_position=to_position.global_position

func show_sprite_hide_NPC(NPC:Node2D,sprite:Node2D):
	sprite.global_position.x=NPC.global_position.x
	sprite.show()
	pass

func talk_and_wait(name,resource,dialogue_name,time=.5,left_side_flag:bool=true):
	EventBus._cutscene_talk(name,resource,dialogue_name)
	await DialogueManager.dialogue_ended
	await get_tree().create_timer(time).timeout
func play_and_wait(ani_name,time=1,SE_LOOP_name="foot_step",SE_NAME="NA"):
	aniplayer.play(ani_name)
	if SE_LOOP_name!="NA":
		EventBus._play_SE_LOOP(SE_LOOP_name,true)
		await aniplayer.animation_finished
		EventBus._play_SE_LOOP(SE_LOOP_name,false)
	elif SE_NAME!="NA":
		EventBus._play_SE_LOOP(SE_NAME,true)
		await aniplayer.animation_finished
		EventBus._play_SE_LOOP(SE_NAME,false)
	await get_tree().create_timer(time).timeout
