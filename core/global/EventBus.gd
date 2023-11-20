@tool
extends Node
##player
signal player_stamina_damaged
signal player_stamina_recovered
signal player_on_fighting_changed
#game
signal player_save_game
signal player_load_game
signal save_game
signal load_game
signal delete_save
signal get_screen_color
signal room_tree_exited
signal running_obj
signal title_2_game
signal to_title_screen()
#vfx
signal fallen_from_top
signal change_player_light
#player
signal player_is_dead
signal player_face_left(state)
signal player_control_lock(state)
signal player_control_locked()
signal dialogue_player_position_update()
signal get_obj_position(obj_name)
signal change_player_position()
signal get_player_position()
signal change_player_visiable(state)
signal change_ifrit_emoji(ani_name,emoji_time,ani_position,emoji_fflip_h)
#cutscene
signal change_npc_state
signal cutscene_play(sceneNum)
signal cutscene_is_playing()
signal load_cutscene(sceneNum)
signal cutscene_finished()
signal cutscene_loaded()
signal next_dialogue()
signal move_2_player()
signal move_2_vec2()
signal change_rooms(rooms:String)
signal change_cutscene(scene_name)
signal transition_show(room)
signal transition_complete()
signal screen_shake(shake_type,state)
signal enable_title_screen_camera(flag)
signal enable_player_camera(flag)
signal title_transition_completed()
signal unlock_doors()
signal lock_doors()
signal change_transition_color()
signal cutscene_camera(dic_markers:Dictionary)
signal cutscene_camera_reset
#BGM
signal play_BGM(BGM_name)
signal play_SE(SE_name)
signal play_SE_LOOP(SE_LOOP_name,state,speed)
#dialogue
signal talk(dialogue_resource:DialogueResource,title:String,dialogue_position:Vector2)
signal cutscene_talk(name,dialogue_resource:DialogueResource,title:String,dialogue_position:Vector2)
signal end_talk()
signal add_interact_time(name)
signal obj_set_face_left(left_flag)
#test
signal db_test
#combat
signal chase_player

func _turn_on_off_light(state):
	if state:
		emit_signal("play_SE","light_switch_on")
	else :
		emit_signal("play_SE","light_switch_off")

func _play_SE_LOOP(SE_LOOP_name,state=true,speed=1.0,effect_volume=0.0):
	play_SE_LOOP.emit(SE_LOOP_name,state,speed,effect_volume)
	
func _play_SE(SE_name,speed=1.0,effect_volume=0.0,owner_name:String="NA",state:bool = true):
	play_SE.emit(SE_name,speed,effect_volume,owner_name,state)
	
func _play_BGM(BGM_name,state=true,speed=1.0,effect_volume=0.0):
	play_BGM.emit(BGM_name,state,speed,effect_volume)

func _change_ifrit_emoji(ani_name="NA",emoji_time:float=3.0,ani_position:String="top",emoji_fflip_h:bool=false):
	change_ifrit_emoji.emit(ani_name,emoji_time,ani_position,emoji_fflip_h)
	pass

func _transition_show(transition_type):
	transition_show.emit(transition_type)
	
func _lock_doors():
	lock_doors.emit()
	
func _unlock_doors():
	unlock_doors.emit()
	
func _player_control_lock(state):
	player_control_lock.emit(state)
	unlock_doors.emit()

func _change_cutscene(scene_name):
	change_cutscene.emit(scene_name)
	CutsceneState.current_cutscene=scene_name
	
func _change_room(rooms):
	if Global.playing_transition:return
	change_rooms.emit(rooms)
	
func _cutscene_play():
	cutscene_play.emit()
func _player_face_left(state:bool=false):
	player_face_left.emit(state)
func _dialogue_player_position_update():
	dialogue_player_position_update.emit()
	
func _next_dialogue():
	next_dialogue.emit()
	
func _talk(obj,dialogue_resource:DialogueResource,title:String,dialogue_position:Vector2,left_side:bool=false,obj_name:String="NA"):
	talk.emit(obj,dialogue_resource,title,dialogue_position,left_side,obj_name)
	
func _cutscene_talk(name:String,dialogue_resource:DialogueResource,title:String):
	EventBus._change_npc_state(name,"talk")
	cutscene_talk.emit(name,dialogue_resource,title)
	await DialogueManager.dialogue_ended
	EventBus._change_npc_state(name,"idle")
func _end_talk():
	end_talk.emit()
	await DialogueManager.dialogue_ended
	
func _get_player_position():
	get_player_position.emit()
	
func _move_2_player(name:String,time:float=1,diatance:int = 0):
	move_2_player.emit(name,time,diatance)
	await get_tree().create_timer(time).timeout
	
func _get_obj_position(obj_name:String):
	get_obj_position.emit(obj_name)
	
func _add_interact_time(obj_name:String):
	add_interact_time.emit(obj_name)
	
func _obj_set_face_left(name,left_flag:bool):
	obj_set_face_left.emit(name,left_flag)
	
func _save_game():
	Debug.dprintinfo("EventBus通知保存游戏……")
	save_game.emit()
	
func _load_game():
	Debug.dprintinfo("EventBus通知读取游戏……")
	load_game.emit()
	
func _player_save_game():
	Debug.dprintinfo("EventBus通知Plyaer保存游戏……")
	player_save_game.emit()	
	
func _player_load_game():
	Debug.dprintinfo("EventBus通知Plyaer载入游戏……")
	player_load_game.emit()	
	
func _enable_title_screen_camera(flag:bool=true):
	enable_title_screen_camera.emit(flag)
	
func _enable_player_camera(flag:bool=true):
	enable_player_camera.emit(flag)
	
func _title_transition_completed():
	title_transition_completed.emit()
	
func _to_title_screen():
	to_title_screen.emit()
	
func _get_screen_color():
	get_screen_color.emit()
	
func _delete_save():
	delete_save.emit()
	
func _fallen_from_top(obj:String,obj_count:int):
	fallen_from_top.emit(obj,obj_count)
	
func _change_transition_color(color:Color=Color.BLACK):
	change_transition_color.emit(color)
	
func _change_player_position(position_p:Vector2):
	change_player_position.emit(position_p)
	
func _db_test():
	db_test.emit()
	
func _room_tree_exited():
	room_tree_exited.emit()
	
func _chase_player(name:String,time:float=1):
	chase_player.emit(name,time)

func _cutscene_camera(dic_markers:Dictionary):
	cutscene_camera.emit(dic_markers)

func _cutscene_camera_reset():
	cutscene_camera_reset.emit()

func _change_player_light(bright:float):
	change_player_light.emit(bright)
	
func _running_obj(name):
	running_obj.emit(name)
	
func _cutscene_finished():
	cutscene_finished.emit()
func _cutscene_is_playing():
	cutscene_is_playing.emit()
func _title_2_game():
	title_2_game.emit()
func _move_2_vec2(name:String,pos:Vector2,time:float=1):
	move_2_vec2.emit(name,pos,time)
func _change_npc_state(npc_name:String,state_name:String):
	change_npc_state.emit(npc_name,state_name)
func _player_stamina_damaged():
	player_stamina_damaged.emit()
func _player_stamina_recovered():
	player_stamina_recovered.emit()
func _player_on_fighting_changed(flag:bool=false):
	player_on_fighting_changed.emit(flag)
