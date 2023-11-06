extends Rooms


func load_vars():
	player_z_index_preset=player.z_index
	Global.room_transition[Global.rooms.ROOM_2]=Global.transition_type.RIGHT_ENTER
	atmosphere_se_dic=[
		["forest-ambient",-20],
		["wind-in-trees",-10]
	]
	
func connect_signals():
	pass

func player_position():
	if Global.last_room==Global.rooms.ROOM_2:
		EventBus._change_player_position(marker_right_door.global_position)
		player_camera.reset_smoothing()
		EventBus._player_face_left(true)
