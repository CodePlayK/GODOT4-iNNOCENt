extends Node
class_name NpcBaseState

#将要赋予的角色
var obj:Area2D
var animation:String="idle"
var balloon
var anisprite
var dialogue_position
var on_player=false
var manager
var npc_name
var dialogue_side_left:bool=true
#初始化事件
func init() -> void:
	set_dialogue_side_left(dialogue_side_left)
#进入该状态的方法，每次进入都会执行，在pre_physics_process之前进行A
func enter() -> void:
	play_animation()
#退出该状态的方法，每次进入都会执行，在physics_process之后进行
func exit():
	pass
#有输入事件的方法,不确定与物理帧方法的顺序。慎用
func input(event: InputEvent) -> NpcBaseState:
	if NpcState.dic_on_player[npc_name]:
		if Input.is_action_just_pressed("interactive"):
			on_player_interactive_talk()
	return null
func on_body_entered():
	set_on_player(true)
	on_player_talk()
func on_body_exited():
	set_on_player(false)
	balloon.hide()
#游戏实际帧数的处理方法，godot默认物理帧FPS为60
#当游戏运行帧数大于物理帧FPS时：可通过传递delta获得与物理帧数同样效果
#而运行帧数小于物理帧数时，即使传递delta也可能导致问题
#运行顺序不确定
func process(delta: float) -> NpcBaseState:
	return null
#物理帧方法，当变量涉及+=或者-+等随时间累计情况时，需要*delta
func physics_process(delta: float) -> NpcBaseState:
	return null
#物理帧中先执行的方法
func pre_physics_process(delta: float)->NpcBaseState:
	return null
func after_physics_process(delta: float)->NpcBaseState:
	return null
func get_npc_faced_direction():
	if obj.base.flip_h == false:
		return -1
	else:
		return 1
func play_animation():
	anisprite.animation=animation

func talk(resource,dialogue_name,time=.5):
	balloon.start(resource,dialogue_name,dialogue_position.global_position,get_dialogue_side_left())
	await DialogueManager.dialogue_ended
	await get_tree().create_timer(time).timeout

func get_on_player():
	return	NpcState.dic_on_player[npc_name]
func set_on_player(state):
	NpcState.dic_on_player[npc_name]=state
func get_dialogue_side_left():
	return	NpcState.dic_dialogue_side_left[npc_name]
func set_dialogue_side_left(state):
	NpcState.dic_dialogue_side_left[npc_name]=state
func on_player_talk():
	return
func on_player_interactive_talk():
	return
