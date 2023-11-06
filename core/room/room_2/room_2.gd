extends Rooms

func init():
	pass
	
func load_vars():
	player_z_index_preset=player.z_index
	Global.room_transition[Global.rooms.ROOM_1]=Global.transition_type.LEFT_ENTER
	atmosphere_se_dic=[
		["forest-ambient",-20],
		["wind-in-trees",-10]
	]
	pass
	
func connect_signals():
	pass
	
func player_position():
	if Global.last_room==Global.rooms.ROOM_1:
		EventBus._change_player_position(marker_left_door.global_position)
		player_camera.reset_smoothing()
		EventBus._player_face_left(false)
