extends Node

var dic_on_player={
	"trainingroomSwitch":false,
	"BathroomSwitch":false,
	"BedroomSwitch":false,
	"SleepLightSwitch":false,
	"DeskBook":false,
	"WaterTap":false,
	"Bedroom2TrainingroomDoor":false,
	"TrainingroomDoor2Bedroom":false,
}

var dic_room_light_state={
	"bedroom": {
		"main":true,
		"sleep":true,
		"desk":true,
		"bathroom":true,
	}	
}
var test={}

func _load_light_state(roomname:String,light_name:String)->bool:
	var room=dic_room_light_state[roomname.to_lower()]
	if  room!=null:
		var light=room[light_name.to_lower()]
		if light!=null:
			return light
	return false

func _save_light_state(roomname:String,light_name:String,state)->void:
	var room=dic_room_light_state[roomname.to_lower()]
	if  room!=null:
		var light=room[light_name.to_lower()]
		if light!=null:
			light=state
	Debug.dprint("未找到该灯光")
