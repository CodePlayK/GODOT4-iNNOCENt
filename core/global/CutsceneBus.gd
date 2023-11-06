@tool
extends Node
func move_2_player(name:String,time:float=1,diatance:int = 0):
	#Debug.dprinterr("move_2_player已经执行!")	
	EventBus._move_2_player(name,time,diatance)
	
func cutscene_talk(name:String,dialogue_resource:DialogueResource,title:String):
	#Debug.dprinterr("cutscene_talk已经执行!")	
	EventBus._cutscene_talk(name,dialogue_resource,title)
	await DialogueManager.dialogue_ended
	
func to_title_screen():
	#Debug.dprinterr("to_title_screen已经执行!")	
	EventBus._to_title_screen()
	
func title_2_game():
	#Debug.dprinterr("title_2_game已经执行!")	
	EventBus._title_2_game()
	
func move_2_vec2(name:String,pos:Vector2,time:float=1):
	EventBus._move_2_vec2(name,pos,time)
	#Debug.dprinterr("move_2_vec2s已经执行!%s" %pos)	
	pass
	
func set_var(var_name:String,value):
	var property_list = get_property_list()
	pass

func test_condition_method(args1:String,args2:String) -> bool:
	return false

func disable_all_ineractable():
	PlayerState.disable_all_ineractable()
	
func enable_all_ineractable():
	PlayerState.enable_all_ineractable()

func change_npc_state(npc_name:String,state_name:String):
	EventBus._change_npc_state(npc_name,state_name)
